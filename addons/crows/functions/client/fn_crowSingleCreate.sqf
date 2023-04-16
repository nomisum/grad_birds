/* 

suggested types:

Eagle_F
Crowe
Kestrel_random_F

["Crowe", position player, 50, 50, 50] call GRAD_crows_fnc_crowCreate;

*/

params ["_type", "_flockPos", "_flockCount", "_density","_flockHeight", "_index"];

/* if (typename _flockPos == typename objnull) then {_flockPos = position _flockPos};*/

_crowList = [];
_relativePositionList = []; // position in flock

for "_i" from 1 to _flockCount do {
	
	_crow = _type camcreate [
		(_flockPos select 0) - _density + (random _density)*2,
		(_flockPos select 1) - _density + (random _density)*2,
		_flockHeight
	];

	missionNamespace setVariable [format ["GRAD_crows_density_%1", _index], _density];
	missionNamespace setVariable [format ["GRAD_crows_flockHeight", _index], _flockHeight];
	missionNamespace setVariable [format ["GRAD_crows_startlingPoint_%1", _index], _flockPos];

	_positionBehind = [3 - random 6, 0 - random 3, 3 - random 6];

	_relativePositionList append [_positionBehind];
	_crowList append [_crow];
	sleep 0.1;
};

[_crowList, _relativePositionList, _index] call GRAD_crows_fnc_crowLoopSingle;

// _veh = "Land_PenBlack_F" createVehicleLocal _flockPos;
// _veh say3D ["fx_crows_takeoff", 250];

_crowList