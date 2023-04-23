params ["_flockManager"];

private _flockOnGround = _flockManager getVariable ["grad_crows_flockOnGround", []];

private _flyingFlock = [];
// create flock async to make animations differ
{
	private _croweGround = _x;
	private _position = (getPos _croweGround);

	private _flyingCrowe = createVehicle ["grad_crowe", _position, [], 0, "CAN_COLLIDE"];

	sleep random 0.1;
	hideObject _croweGround;
	_flyingFlock pushBackUnique _flyingCrowe;
} forEach _flockOnGround;

_flockManager setVariable ["grad_crows_flying", _flyingFlock];

[_flockManager, ["fx_crows_takeoff", 100]] remoteExec ["say3d"];

diag_log ("startle flockmanager: " + str _flockManager + " - flock: " + str _flyingFlock);

[_flockManager] call grad_crows_fnc_startleStartFSM;
