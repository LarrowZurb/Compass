
params[ "_init" ];

if ( _init == "postInit" ) exitWith {
	if ( hasInterface ) then {
		[ "INIT" ] spawn ( missionNamespace getVariable _fnc_scriptName );
	};
};

waitUntil{ !isNull findDisplay 46 };

LARs_compass_icons = [];
LARs_compass_shown = true;
LARs_compass_iconColor = [ getArray( missionConfigFile >> "LARs_UICompass_settings" >> "iconColor" ) ] param[ 0, [0,1,0,1], [ [] ], [ 4 ] ];

"LARs_UICompass" call BIS_fnc_rscLayer cutRsc [ "LARs_UICompass", "PLAIN", -1, false ];

{
	_icon = _x getVariable "LARs_compass_icon";
	if ( !isNil "_icon" ) then {
		_iconIndex = [ "ADD", [ _icon, _x ] ] call LARs_compass_fnc_icon;
		_x setVariable[ "LARs_compass_iconIndex", _iconIndex ];
	};
}forEach ( allMissionObjects "" );