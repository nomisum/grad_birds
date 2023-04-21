// check after timeout if crows can land again, do nothing if timeout got pushed further by another instance 
params ["_flockManager"];

[{
	params ["_flockManager"];

	private _canLand = (CBA_missionTime - grad_crows_firedTimeout) > (_flockManager getVariable ["grad_crows_lastMovement", CBA_missionTime]);
	if (_canLand) then {
		_flockManager setVariable ["grad_crows_startled", false, true];

		private _detectors = _flockManager getVariable ["grad_crows_detectors", []];
		_detectors#0 setObjectTextureGlobal [0, "#(rgb,8,8,3)color(0,1,0,0.1)"];
	};
	
}, [_flockManager], grad_crows_firedTimeout + 1] call CBA_fnc_waitAndExecute;