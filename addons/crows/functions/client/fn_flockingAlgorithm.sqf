params ["_flockManager", "_flock"];

private _flockPos = getPos _flockManager;
private _flockArea = random 30 max 20;
private _flockHeight = 30 + random 10;

_flockPos set [2,_flockHeight];
private _wp0 = ([_flockPos, _flockArea, 0] call BIS_fnc_relPos);
private _wp1 = ([_flockPos, _flockArea, 90] call BIS_fnc_relPos);
private _wp2 = ([_flockPos, _flockArea, 180] call BIS_fnc_relPos);
private _wp3 = ([_flockPos, _flockArea, 270] call BIS_fnc_relPos);

private _flyingCrows = _flocksManager getVariable ["grad_crows_flying", []];
{
	private _flyingCrow = [_x, _wp0, _wp1, _wp2, _wp3, _flockArea, _flockManager, _foreachindex] execfsm "crows\data\fn_crows.fsm";
	_flyingCrows pushBackUnique _flyingCrow;
} forEach _flock;
_flocksManager setVariable ["grad_crows_flying", _flyingCrows];




// all crows must know leadcrow
// [_flockManager, _flock, _wps] call grad_crows_fnc_crowLoop;
