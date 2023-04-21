params ["_crow", "_index"];

_waypoint = [0,0,0]; // fallback
private _startlingPoint = missionNamespace getVariable [format ["GRAD_crows_startlingPoint_%1", _index], []];
private _circlePoint = missionNamespace getVariable [format ["GRAD_crows_circlePoint_%1", _index], []];
private _despawnPoint = missionNamespace getVariable [format ["GRAD_crows_despawnPoint_%1", _index], []];

// systemChat format ["_circlePoint %1, _index %2", _circlePoint, _index];

// startling point
/*
if (count _startlingPoint == 0) then { 
	_waypoint = getPos _crow; _waypoint set [2,100];
};
*/

// circle point - get next wp
if (count _circlePoint > 0) then {

	_circlePoint set [2, 10 + (_circlePoint select 2) + (random 2) - (random 4)];
	_waypoint = _circlePoint;
};


// despawn point
if (count _despawnPoint > 0) then { 
	_waypoint = _despawnPoint;
};

_waypoint