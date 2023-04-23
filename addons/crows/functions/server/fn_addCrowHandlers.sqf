params ["_crow"];

_crow addMPEventHandler ["MPHit", {
	params ["_unit", "_causedBy", "_damage", "_instigator"];

	if (local _unit) then {
		private _flockManager = _unit getVariable ["grad_crows_flockManager", objNull];
		private _flock = _flockManager getVariable ["grad_crows_flying", []];

		_flock deleteAt (_flock find _unit);
		_flockManager setVariable ["grad_crows_flying", _flock];

		[getPos _unit] remoteExec ["grad_crows_fnc_splatter"];
		deleteVehicle _unit;
	};
}];
