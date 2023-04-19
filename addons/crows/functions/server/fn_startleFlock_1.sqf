params ["_positionUnit", "_positionFirer", "_flock"];


private _flyingFlock = [];
{
	private _croweGround = _x;
	private _position = (getPos _croweGround);
	_position set [2, _position#2 + 2];
	private _flyingCrowe = createvehicle ["crowe", _position, [], 0, "CAN_COLLIDE"];

	deletevehicle _croweGround;

	_flyingFlock pushBackUnique _flyingCrowe;
} forEach _flock;

[_flyingFlock] call grad_crows_fnc_flockingAlgorithm;
