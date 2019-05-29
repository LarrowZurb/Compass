
#include "..\ui\IDCs.sqc"

disableSerialization;

params[ "_map" ];

_ctrlGrp = ctrlParentControlsGroup _map;
_display = ctrlParent _ctrlGrp;
_compass = _ctrlGrp controlsGroupCtrl COMPASS_IMG;

if ( isNil "LARs_Compass_configured" ) then {
	[ _map ] call LARs_Compass_fnc_configure;
};

_cameraPos = getPosATL player vectorAdd getCameraViewDirection player;
_dir = getPosATL player getDir _cameraPos;
_posX = linearConversion[ 0, 360, _dir, 1536 * LARs_compass_scale, 3072 * LARs_compass_scale, true ];
ctrlPosition _compass params[ "_ctrlX", "_ctrlY" ];
_compass ctrlSetPosition[ -( _posX * pixelW ), _ctrlY ];
_compass ctrlCommit 0;

_iconW = 48 * pixelW * LARs_compass_scale;
_iconH = 48 * pixelH * LARs_compass_scale;
ctrlPosition _ctrlGrp params[ "_grpX", "_grpY", "_grpW", "_grpH" ];

{
	if ( _x isEqualType [] ) then {
		_x params[ "_icon", "_pos", "_iconColor", [ "_ctrl", controlNull ], [ "_active", false ] ];

		_iconWidth = _iconW * ( [ 1, LARs_compass_activeIconScale ] select _active );
		_iconHeight = _iconH * ( [ 1, LARs_compass_activeIconScale ] select _active );

		if ( isNull _ctrl ) then {
			_ctrl = _display ctrlCreate [ "ctrlActivePicture", COMPASS_ICONS + _forEachIndex, _ctrlGrp ];
			_ctrl ctrlSetPosition[ 0 + ( _grpW / 2 ) - ( _iconWidth / 2 ), _grpH - _iconHeight, _iconWidth, _iconHeight ];
			_ctrl ctrlSetText _icon;
			_ctrl ctrlSetTextColor _iconColor;
			_ctrl ctrlCommit 0;
			LARs_compass_icons select _forEachIndex set[ 3, _ctrl ];
		};

		_posDir = switch ( true ) do {
			case ( _pos isEqualType [] ) : {
				if !( isNull _pos ) then {
					player getRelDir _pos
				};
			};
			case ( _pos isEqualType objNull ) : {
				if !( isNull _pos ) then {
					player getRelDir getPosATLVisual _pos
				};
			};
			case ( _pos isEqualType locationNull ) : {
				if !( isNull _pos ) then {
					player getRelDir locationPosition _pos
				};
			};
			case ( _pos isEqualType "" ) : {
				if !( getMarkerPos _pos isEqualTo [0,0,0] ) then {
					player getRelDir getMarkerPos _pos
				};
			};
		};

		if !( isNil "_posDir" || isNull _ctrl ) then {
			_posDir = (( _posDir +180 ) % 360 );
			_posX = linearConversion[ 90, 270, _posDir, 0, _grpW ];
			//ctrlPosition _ctrl params[ "_ctrlX", "_ctrlY" ];
			_ctrl ctrlSetPosition[ _posX - ( _iconWidth / 2 ), _grpH - _iconHeight, _iconWidth, _iconHeight ];
			_ctrl ctrlCommit 0;
		}else{
			if !( isNull _ctrl ) then {
				ctrlDelete _ctrl;
			};
			LARs_compass_icons set[ _forEachIndex, objNull ];
		};
	};
}forEach LARs_compass_icons;

LARs_compass_icons = LARs_compass_icons - [ objNull ];