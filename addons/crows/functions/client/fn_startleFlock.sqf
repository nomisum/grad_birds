params ["_flockManager"];

private _flockOnGround = _flockManager getVariable ["grad_crows_flockOnGround", []];

private _flyingFlock = [];
{
	private _croweGround = _x;
	private _position = (getPos _croweGround);
	private _flyingCrowe = "crowe" camCreate _position;

	// hide crow locally when it startles
	hideObject _croweGround;

	_flyingFlock pushBackUnique _flyingCrowe;
} forEach _flockOnGround;

_flockManager say3d ["fx_crows_takeoff", 100];

systemChat ("startle " + str _flockManager);
diag_log ("startle " + str _flockManager);
[{
	_this call grad_crows_fnc_flockingAlgorithm;
}, [_flockManager, _flyingFlock], 1] call CBA_fnc_waitAndExecute;
