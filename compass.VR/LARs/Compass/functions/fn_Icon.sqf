
params[
	[ "_mode", "", [ "" ] ],
	"_this"
];

switch ( toUpper _mode ) do {

	case ( "ADD" ) : {
		params[
			[ "_iconType", "", [ "" ] ],
			[ "_worldPos", objNull, [ objNull, locationNull, "", [] ], [ 2, 3 ] ],
			[ "_iconColor", LARs_compass_iconColor, [ [] ], [ 4 ] ],
			[ "_active", false, [ true ] ]
		];

		if ( _worldPos isEqualType "" && { getMarkerPos _worldPos isEqualTo [0,0,0] } ) exitWith {
			"Non existent marker used" call BIS_fnc_error;
		};

		if !( isClass( configFile >> "CfgTaskTypes" >> _iconType ) ) exitWith {
			"Invalid Task Type Icon" call BIS_fnc_error;
		};

		_icon = getText( configFile >> "CfgTaskTypes" >> _iconType >> "icon" );

		_index = LARs_compass_icons findIf{ _x isEqualType objNull && { isNull _x } };
		_iconIndex = if ( _index > -1 ) then {
			LARs_compass_icons set[ _index, [ _icon, _worldPos, _iconColor ] ];
			_index
		}else{
			LARs_compass_icons pushBack [ _icon, _worldPos, _iconColor ];
		};

		if ( _active ) then {
			[ "ACTIVE", [ _iconIndex ] ] call LARs_compass_fnc_icon;
		};

		_iconIndex
	};

	case ( "REM" ) : {
		params[ "_iconIndex" ];

		if ( count LARs_compass_icons > _iconIndex && { LARs_compass_icons select _iconIndex isEqualType [] } ) then {
			_ctrl = LARs_compass_icons select _iconIndex select 3;
			if !( isNull _ctrl ) then {
				ctrlDelete _ctrl;
			};
			LARs_compass_icons set[ _iconIndex, objNull ];
		};
	};

	case ( "COLOR" ) : {
		params[ "_iconIndex", [ "_color", [1,1,1,1], [ [] ], [ 4 ] ] ];

		if ( count LARs_compass_icons > _iconIndex && { LARs_compass_icons select _iconIndex isEqualType [] } ) then {
			_ctrl = LARs_compass_icons select _iconIndex select 3;
			if !( isNull _ctrl ) then {
				_ctrl ctrlSetTextColor _color;
			};
		};
	};

	case ( "ACTIVE" ) : {
		params[ "_iconIndex" ];

		if ( count LARs_compass_icons > _iconIndex && { LARs_compass_icons select _iconIndex isEqualType [] } ) then {
			{
				LARs_compass_icons select _forEachIndex set[ 4, [ false, true ] select ( _forEachIndex isEqualTo _iconIndex ) ];
			}forEach LARs_compass_icons;
		};
	};

};
