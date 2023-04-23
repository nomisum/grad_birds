params ["_flockManager"];

private _flockOnGround = _flockManager getVariable ["grad_crows_flockOnGround", []];

private _flyingFlock = [];
// create flock async to make animations differ
{
	private _croweGround = _x;
	private _position = (getPos _croweGround);
	private _flyingCrowe = "crowe" camCreate _position;
	_flyingCrowe hideObject true;
	sleep random 0.1;

	_flyingFlock pushBackUnique _flyingCrowe;
} forEach _flockOnGround;

{
	_flyingFlock#_foreachindex hideObject _false;
	// hide crow locally when it startles
	hideObject _croweGround;
} forEach _flockOnGround;

_flockManager say3d ["fx_crows_takeoff", 100];

systemChat ("startle " + str _flockManager);
diag_log ("startle " + str _flockManager);
[{
	_this call grad_crows_fnc_flockingAlgorithm;
}, [_flockManager, _flyingFlock], 1] call CBA_fnc_waitAndExecute;
