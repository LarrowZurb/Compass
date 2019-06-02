
#define ICON			0
#define POS				1
#define COLOR			2
#define CTRL			3
#define ACTIVE			4
#define FLASH_DATA		5


#define VALID_INDEX( index ) index > -1 && { count LARs_compass_icons > index && { LARs_compass_icons select index isEqualType [] }}

if !( canSuspend ) exitWith {
	_this spawn LARs_compass_fnc_icon;
};

if ( isNil "LARs_Compass_configured" ) then {
	waitUntil { !isNil "LARs_Compass_configured" };
};

params[
	[ "_mode", "", [ "" ] ],
	[ "_this", [], [ [] ] ]
];

switch ( toUpper _mode ) do {

	case ( "ADD" ) : {
		params[
			[ "_iconType", "", [ "" ] ],
			[ "_worldPos", objNull, [ objNull, locationNull, "", [] ], [ 2, 3 ] ],
			[ "_iconColor", [], [ [] ], [ 0, 4 ] ],
			[ "_active", false, [ true ] ]
		];

		//#Region "error checking"

		//Icon
		if (
			!isClass( configFile >> "CfgTaskTypes" >> _iconType ) &&
			{ !isClass( missionConfigFile >> "LARs_CompassIcons" >> _iconType ) }
		) exitWith {
			format[ "Invalid icon type: %1", _iconType ] call BIS_fnc_error;
		};

		//Position
		if !( [ "CHK_POS", [ _worldPos ] ] call LARs_compass_fnc_icon ) exitWith {};

		//Color
		if ( { !( _x isEqualType 0 ) }count _iconColor > 0 ) exitWith {
			format[ "Bad icon color: %1", _iconColor ] call BIS_fnc_error;
		};

		//Active
		if !( _active isEqualType true ) exitWith {
			format[ "Invalid icon active: %1", _active ] call BIS_fnc_error;
		};

		//#End Region

		_iconData = if ( isClass( missionConfigFile >> "LARs_CompassIcons" >> _iconType ) ) then {
			_cfg = missionConfigFile >> "LARs_CompassIcons" >> _iconType;
			[
				[ getText( configFile >> "CfgTaskTypes" >> _iconType >> "intel" ), getText( _cfg >> "icon" ) ] select ( isText( _cfg >> "icon" )),
				_worldPos,
				[
					[ _iconColor, LARs_compass_iconColor ] select ( _iconColor isEqualTo [] ),
					[ LARs_compass_iconColor, getArray( _cfg >> "color" ) ] select ( count getArray( _cfg >> "color" ) isEqualTo 4 )
				] select ( _iconColor isEqualTo [] && { isArray( _cfg >> "color" ) } ),
				controlNull,
				_active,
				[
					[ getArray( _cfg >> "flashColor" ) ] param[ 0, [], [ [] ], [ 0, 4 ] ],
					getNumber( _cfg >> "flashDuration" ),
					getNumber( _cfg >> "pingPong" )
				]
			]
		}else{
			_cfg = configFile >> "CfgTaskTypes" >> _iconType;
			[ getText( _cfg >> "icon" ), _worldPos, [ _iconColor, LARs_compass_iconColor ] select ( _iconColor isEqualTo [] ) ];
		};

		_iconIndex = LARs_compass_icons pushBack _iconData;

		if ( _active ) then {
			[ "ACTIVE", [ _iconIndex ] ] call LARs_compass_fnc_icon;
		};

		_iconIndex
	};

	case ( "REM" ) : {
		params[ [ "_iconIndex", -1, [ 0 ] ] ];

		if ( VALID_INDEX( _iconIndex ) ) then {
			_ctrl = LARs_compass_icons select _iconIndex select CTRL;
			if !( isNull _ctrl ) then {
				ctrlDelete _ctrl;
			};
			LARs_compass_icons set[ _iconIndex, objNull ];
		};
	};

	case ( "ICON" ) : {
		params[
			[ "_iconIndex", -1, [ 0 ] ],
			[ "_iconType", "", [ "" ] ]
		];

		if (
			!isClass( configFile >> "CfgTaskTypes" >> _iconType ) &&
			{ !isClass( missionConfigFile >> "LARs_CompassIcons" >> _iconType ) }
		) exitWith {
			format[ "Invalid icon type: %1", _iconType ] call BIS_fnc_error;
		};

		_icon = if ( isClass( missionConfigFile >> "LARs_CompassIcons" >> _iconType ) ) then {
			getText( missionConfigFile >> "LARs_CompassIcons" >> _iconType >> "icon" )
		}else{
			getText( configFile >> "CfgTaskTypes" >> _iconType >> "icon" );
		};

		if ( VALID_INDEX( _iconIndex ) ) then {
			LARs_compass_icons select _iconIndex set[ ICON, _icon ];
		};
	};

	case ( "POSITION" ) : {
		params[
			[ "_iconIndex", -1, [ 0 ] ],
			[ "_worldPos", objNull, [ objNull, locationNull, "", [] ], [ 2, 3 ] ]
		];

		if !( [ "CHK_POS", [ _worldPos ] ] call LARs_compass_fnc_icon ) exitWith {};

		if ( VALID_INDEX( _iconIndex ) ) then {
			LARs_compass_icons select _iconIndex set[ POS, _worldPos ];
		};
	};

	case ( "COLOR" ) : {
		params[
			[ "_iconIndex", -1, [ 0 ] ],
			[ "_color", [1,1,1,1], [ [] ], [ 4 ] ]
		];

		if ( { !( _x isEqualType 0 ) }count _color > 0 ) exitWith {
			format[ "Bad icon color: %1", _color ] call BIS_fnc_error;
		};

		if ( VALID_INDEX( _iconIndex ) ) then {
			_ctrl = LARs_compass_icons select _iconIndex select CTRL;
			if !( isNull _ctrl ) then {
				//No way to get controls current color
				//So just update ctrl text color here
				_ctrl ctrlSetTextColor _color;
			};
		};
	};

	case ( "ACTIVE" ) : {
		params[ [ "_iconIndex", -1, [ 0 ] ] ];

		if ( VALID_INDEX( _iconIndex ) ) then {
			{
				LARs_compass_icons select _forEachIndex set[ ACTIVE, [ false, true ] select ( _forEachIndex isEqualTo _iconIndex ) ];
			}forEach LARs_compass_icons;
		};
	};

	case ( "FLASH" ) : {
		params[
			[ "_iconIndex", -1, [ 0 ] ],
			[ "_colorTo", [], [ [] ], [ 0, 4 ] ],
			[ "_duration", 1, [ 0 ] ],
			[ "_pingPong", true, [ true ] ],
			[ "_colorFrom", [], [ [] ], [ 0, 4 ] ]
		];

		if ( VALID_INDEX( _iconIndex ) ) then {
			if ( _colorFrom isEqualTo [] ) then {
				_colorFrom = LARs_compass_icons select _iconIndex select COLOR;
			}else{
				[ "COLOR", [ _iconIndex, _colorFrom ] ] call LARs_compass_fnc_icon;
			};

			if ( _colorTo isEqualTo [] ) then {
				_colorTo = LARs_compass_icons select _iconIndex select COLOR;
			};

			if ( _colorFrom isEqualTo _colorTo ) then {
				//Use to reset FLASH
				LARs_compass_icons select _iconIndex set[ FLASH_DATA, [] ];
				[ "COLOR", [ _iconIndex, _colorFrom ] ] call LARs_compass_fnc_icon;
				//format[ "Color from: %1 is the same as color to: %2", _colorFrom, _colorTo ] call BIS_fnc_error;
			}else{
				LARs_compass_icons select _iconIndex set[ FLASH_DATA, [ _colorTo, _duration, _pingPong ] ];
			};

		};
	};

	//For internal use only
	case ( "CHK_POS" ) : {
		params[ [ "_pos", objNull, [ objNull, locationNull, "", [] ], [ 2, 3 ] ] ];

		if ( _worldPos isEqualType "" && { getMarkerPos _worldPos isEqualTo [0,0,0] } ) exitWith {
			format[ "Non existent marker used: '%1'", _worldPos ] call BIS_fnc_error;
			false
		};

		if ( _worldPos isEqualTypeAny[ objNull, locationNull ] && { isNull _worldPos } ) exitWith {
			format[ "Bad position: %1", _worldPos ] call BIS_fnc_error;
			false
		};

		if ( _worldPos isEqualType [] && { { !( _x isEqualType 0 ) }count _worldPos > 0 } ) exitWith {
			format[ "Bad position: %1", _worldPos ] call BIS_fnc_error;
			false
		};

		true
	};
};
