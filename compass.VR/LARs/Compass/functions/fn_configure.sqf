
#include "..\ui\IDCs.sqc"
#include "..\ui\gridMacros.sqc"

params[ "_map" ];

_config = missionConfigFile >> "LARs_UICompass_settings";

LARs_compass_scale = getNumber( _config >> "scale" );
_backgroundColor = getArray( _config >> "backgroundColor" );
_compassColor = getArray( _config >> "compassColor" );
_centerColor = getArray( _config >> "centerColor" );
_bottom = [ false, true ] select getNumber( _config >> "bottom" );

{
	_x params[ "_ctrl", "_changePos", [ "_color", [ 1, 1, 1, 1 ] ] ];
	_changePos params[ "_effectX", "_effectY", "_effectW", "_effectH" ];

	ctrlPosition _ctrl params[ "_ctrlX", "_ctrlY", "_ctrlW", "_ctrlH" ];

	_ctrl ctrlSetTextColor _color;

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

}forEach [
	[ ctrlParentControlsGroup _map, [ true, true, true, true ] ],
	[ ctrlParentControlsGroup _map controlsGroupCtrl COMPASS_IMG, [ false, false, true, true ], _compassColor ],
	[ ctrlParentControlsGroup _map controlsGroupCtrl COMPASS_BACK, [ false, false, true, true ], _backgroundColor ],
	[ ctrlParentControlsGroup _map controlsGroupCtrl COMPASS_CENTER, [ false, false, true, true ], _centerColor ]
];

_ctrl = ctrlParentControlsGroup _map controlsGroupCtrl COMPASS_CENTER;
ctrlPosition _ctrl params[ "_ctrlX", "_ctrlY", "_ctrlW", "_ctrlH" ];
_ctrlGrp = ctrlParentControlsGroup _map;
ctrlPosition _ctrlGrp params[ "", "", "_ctrlGrpW" ];

_ctrl ctrlSetPosition[ ( _ctrlGrpW / 2 ) - ( _ctrlW / 2 ), _ctrlY  ];
_ctrl ctrlCommit 0;

LARs_Compass_configured = true;