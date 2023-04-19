params ["_positionUnit", "_positionFirer", "_flock"];


private _flyingFlock = [];
{
	private _croweGround = _x;
	private _position = (getPos _croweGround);
	private _flyingCrowe = "crowe" camCreate _position;

	deletevehicle _croweGround;

	_flyingFlock pushBackUnique _flyingCrowe;
} forEach _flock;

[_flyingFlock] call grad_crows_fnc_flockingAlgorithm;
