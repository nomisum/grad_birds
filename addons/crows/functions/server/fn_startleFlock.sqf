params ["_positionUnit", "_positionFirer", "_flock"];


private _flyingFlock = [];
{
	private _croweGround = _x;
	private _flyingCrowe = createvehicle ["crowe", (ASLToAGL getPosASL _croweGround), [], 0, "CAN_COLLIDE"];
	deletevehicle _croweGround;

	_flyingFlock pushBackUnique _flyingCrowe;
} forEach _flock;

[_flyingFlock] call grad_crows_fnc_flockingAlgorithm;
