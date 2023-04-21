params ["_flockManager", "_flock"];

private _flockPos = getPos _flockManager;
private _flockArea = random 100 max 25;
private _flockHeight = 30 + random 10;

_flockPos set [2,_flockHeight];
private _wp0 = [_flockPos, _flockArea, 00] call BIS_fnc_relPos;
private _wp1 = [_flockPos, _flockArea, 090] call BIS_fnc_relPos;
private _wp2 = [_flockPos, _flockArea, 180] call BIS_fnc_relPos;
private _wp3 = [_flockPos, _flockArea, 270] call BIS_fnc_relPos;
private _wps = [_wp0,_wp1,_wp2,_wp3];

systemChat ("flalgo " + str _flockManager);
diag_log ("flalgo " + str _flockManager);

// all crows must know leadcrow
[_flockManager, _flock, _wps] call grad_crows_fnc_crowLoop;
