
params[ "_init" ];

if ( _init == "postInit" ) exitWith {
	[ "INIT" ] spawn ( missionNamespace getVariable _fnc_scriptName );
};

waitUntil{ !isNull findDisplay 46 };

//_display = findDisplay 46 createDisplay "LARs_UICompass";

"LARs_UICompass" call BIS_fnc_rscLayer cutRsc [ "LARs_UICompass", "PLAIN", -1, false ];