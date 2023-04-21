
private _flockCount = 60; // count of flocks distributed over map

private _flockSizeMin = 1; // minimum size of birds on one position
private _flockSizeMax = 35; // maximum size of birds on one position

if (count grad_crows_mapPositions < 1) exitWith { diag_log "no suitable objects for grad crows found"};

private _allFlocks = [];

// count of flocks
for "_i" from 1 to _flockCount do {
	private _size = floor (random _flockSizeMax) max _flockSizeMin;
	private _targetObject = selectRandom grad_crows_mapPositions;
	private _flockManager = (creategroup sideLogic) createUnit ["Logic", getPos _targetObject, [], 0, "NONE"];
    ([_targetObject] call grad_crows_fnc_getObjectDimensions) params ["_width", "_length", "_height"];

	private _flockSingle = [];
	// count of birds in flock
	for "_k" from _flockSizeMin to _size do {
		private _position = [[_width, _length, getDir _targetObject, true]] call BIS_fnc_randomPos;

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

			private _crowe = createSimpleObject ["\crows\data\seagull_modified6.p3d", _positionFromArray, false]; 
			_crowe setDir (random 360);

			[_positionFromArray] call grad_crows_fnc_debugMarker;

			_flockSingle pushBackUnique _crowe;		
		};
		
		if (count _flockSingle > 0 ) then {
			_flockManager setVariable ["grad_crows_flockOnGround", _flockSingle];
			[_flockManager] call grad_crows_fnc_createDetector;
		};
	};
	_allFlocks pushBackUnique _flockManager;
};

_allFlocks
