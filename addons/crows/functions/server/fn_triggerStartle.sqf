params ["_flockManager"];

private _flock = _flockManager getVariable ["grad_crows_flockOnGround", []];
systemchat ("triggerstartle: " + str _flockManager);
diag_log ("triggerstartle: " + str _flockManager);


if (_flockManager getVariable ["grad_crows_startled", false]) exitWith {
	_flockManager setVariable ["grad_crows_lastMovement", CBA_missionTime, true];

	[_flockManager] call grad_crows_fnc_checkTimeout;
};

_flockManager setVariable ["grad_crows_startled", true];
[_flockManager] call grad_crows_fnc_checkTimeout;


[_flockManager] spawn grad_crows_fnc_startleFlock; // global crow


// move detectors to new landingposition to manage further
private _position = getPos _flockManager;
private _distance = 150;
private _possiblePositions = [];
private _targetObject = objNull;

for "_i" from 1 to 50 do {
	_targetObject = selectRandom grad_crows_mapPositions;

	if (_targetObject distance _position < _distance) exitWith {};
};

([_targetObject] call grad_crows_fnc_getObjectDimensions) params ["_width", "_length", "_height"];

for "_k" from 1 to count _flock do {
		private _position = _targetObject getPos [(random _width/2) min (random _length/2), random 360];

		private _positionsOnTopASL = (lineIntersectsSurfaces [
			_position vectorAdd [0, 0, 50],
			_position,
			objNull,
			objNull,
			true,
			-1,
			"VIEW"
		]);

		if (count _positionsOnTopASL > 0) then {
			private _positionFromArray = (_positionsOnTopASL select 0 select 0);
			// systemchat str _positionFromArray;

			(_flock select _k) setPosASL _positionFromArray;
			_crowe setDir (random 360);

			[_positionFromArray] call grad_crows_fnc_debugMarker;	
		};
};



private _detectors = _flockManager getVariable ["grad_crows_detectors", []];
{
	// Current result is saved in variable _x
	private _detector = _x;
	_detector setPos getPos _targetObject;
	_flockManager setPos getPos _targetObject;
} forEach _detectors;

_detectors#0 setObjectTextureGlobal [0, "#(rgb,8,8,3)color(1,0,0,0.1)"];
