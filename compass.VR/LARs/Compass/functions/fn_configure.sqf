
#include "..\ui\IDCs.sqc"
#include "..\ui\gridMacros.sqc"

params[ "_map" ];

_config = missionConfigFile >> "LARs_UICompass_settings";

LARs_compass_scale = getNumber( _config >> "scale" ) param[ 0, 0.4, [ 0 ] ];
_backgroundColor = [ getArray( _config >> "backgroundColor" ) ] param[ 0, [0,0,0,0], [ [] ], [ 4 ] ];
_compassColor = [ getArray( _config >> "compassColor" ) ] param[ 0, [1,1,1,1], [ [] ], [ 4 ] ];
_centerColor = [ getArray( _config >> "centerColor" ) ] param[ 0, [0.910,0.561,0.145,1], [ [] ], [ 4 ] ];
LARs_compass_activeIconScale = getNumber( _config >> "activeIconScale" ) param[ 0, 1.5, [ 0 ] ];
LARs_compass_iconSize = getNumber( _config >> "iconSize" ) param[ 0, 48, [ 0 ] ];
_bottom = [ false, true ] select ( getNumber( _config >> "bottom" ) param[ 0, 0, [ 0 ] ] );

{
	_x params[ "_ctrl", "_changePos", [ "_color", [1,1,1,1] ], [ "_image", "" ] ];
	_changePos params[ "_effectX", "_effectY", "_effectW", "_effectH" ];

	ctrlPosition _ctrl params[ "_ctrlX", "_ctrlY", "_ctrlW", "_ctrlH" ];

	if ( _effectW ) then {
		_ctrlW = _ctrlW * LARs_compass_scale;
	};
	if ( _effectH ) then {
		_ctrlH = _ctrlH * LARs_compass_scale;
	};
	if ( _effectX ) then {
		_ctrlX = ( safeZoneX + ( safeZoneW / 2 ) - ( _ctrlW / 2 ) );
	};
	if ( _effectY ) then {
		if ( _bottom ) then {
			_ctrlY = safeZoneY + safeZoneH - VERTICAL_GUTTER - _ctrlH;
		};
	};

	_ctrl ctrlSetPosition[ _ctrlX, _ctrlY, _ctrlW, _ctrlH ];
	_ctrl ctrlCommit 0;

	if !( _image isEqualTo "" ) then {
		_ctrl ctrlSetText _image;
		_ctrl ctrlSetTextColor _color;
	};

}forEach [
	[ ctrlParentControlsGroup _map, [ true, true, true, true ] ],
	[ ctrlParentControlsGroup _map controlsGroupCtrl COMPASS_IMG, [ false, false, true, true ], _compassColor, "LARs\Compass\ui\images\compass.paa" ],
	[ ctrlParentControlsGroup _map controlsGroupCtrl COMPASS_BACK, [ false, false, true, true ], _backgroundColor, "#(rgb,8,8,3)color(1,1,1,1)" ],
	[ ctrlParentControlsGroup _map controlsGroupCtrl COMPASS_CENTER, [ false, false, true, true ], _centerColor, "LARs\Compass\ui\images\center.paa" ]
];

_ctrl = ctrlParentControlsGroup _map controlsGroupCtrl COMPASS_CENTER;
ctrlPosition _ctrl params[ "_ctrlX", "_ctrlY", "_ctrlW", "_ctrlH" ];
_ctrlGrp = ctrlParentControlsGroup _map;
ctrlPosition _ctrlGrp params[ "", "", "_ctrlGrpW" ];

_ctrl ctrlSetPosition[ ( _ctrlGrpW / 2 ) - ( _ctrlW / 2 ), _ctrlY  ];
_ctrl ctrlCommit 0;

if ( isNil "LARs_compass_toggleKey_EH" && { isNumber( _config >> "toggleKey" ) } ) then {
	LARs_compass_toggleKey = getNumber( _config >> "toggleKey" );

	LARs_compass_toggleKey_EH = findDisplay 46 displayAddEventHandler [ "KeyUp", {
		params[ "_display", "_keyCode", "_shft", "_ctr", "_alt" ];

		if ( _keyCode isEqualTo LARs_compass_toggleKey ) then {
			if ( LARs_compass_shown ) then {
				"LARs_UICompass" call BIS_fnc_rscLayer cutText [ "", "PLAIN", -1, false ];
				LARs_compass_shown = false;
			}else{
				LARs_Compass_configured = nil;
				"LARs_UICompass" call BIS_fnc_rscLayer cutRsc [ "LARs_UICompass", "PLAIN", -1, false ];
				LARs_compass_shown = true;
			};
		};
	}];
};

LARs_Compass_configured = true;