
#include "..\ui\IDCs.sqc"

disableSerialization;

params[ "_map" ];

_compass = ctrlParentControlsGroup _map controlsGroupCtrl COMPASS_IMG;

if ( isNil "LARs_Compass_configured" ) then {
	[ _map ] call LARs_Compass_fnc_configure;
};


_dir = [0,0,0] getDir getCameraViewDirection player;
_posX = linearConversion[ 0, 360, _dir, 1536 * LARs_compass_scale, 3072 * LARs_compass_scale, true ];
ctrlPosition _compass params[ "_ctrlX", "_ctrlY" ];
_compass ctrlSetPosition[ -( _posX * pixelW ), _ctrlY ];
_compass ctrlCommit 0;

