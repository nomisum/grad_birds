// Boids algorithm in SQF
// Author: ChatGPT + nomi in harmonic collab

// Define the _boid object
params ["_flock"];

private _debugmultiplier = 0.1;

// Define the parameters
grad_crows_separation_dist = 5;
grad_crows_alignment_dist = 20;
grad_crows_cohesion_dist = 50;
grad_crows_max_speed = 20*_debugmultiplier;
grad_crows_max_force = 10*_debugmultiplier;
grad_crows_interval = 1;

private _initialTargetPoint = getPosASL (_flock select 0);
_initialTargetPoint set [2, _initialTargetPoint#2+20];

// Define the main loop
[{
	params ["_args", "_handle"];
	_args params ["_thisFlock", "_initialTargetPoint"];

	{
		private _boid = _x;
		// Get the current position and velocity of the _boid
		private _posPrevious = getPos _boid;
		private _velPrevious = velocity _boid;
		private _vectorUpPrevious = vectorDirVisual _boid;
		private _vectorDirPrevious = vectorDirVisual _boid;

		private _currentTime = diag_tickTime;
		private _lastSeen = _boid getVariable ["grad_crows_lastSeen",diag_tickTime];
		private _timeSinceLastSeen = _currentTime - _lastSeen;

		// Find the neighboring _boids
		private _neighbors = [];
		{
			private _neighbour = _x;
			if (
				_neighbour != _boid && alive _neighbour && vehicle _neighbour == _boid && 
				(getPos _neighbour distance _posPrevious) < grad_crows_cohesion_dist
				) then {
				_neighbors pushBack _neighbour;
			};
		} forEach _thisFlock;

		// Calculate the separation, alignment, and cohesion vectors
		private _separation = [0, 0, 0];
		private _alignment = [0, 0, 0];
		private _cohesion = [0, 0, 0];
		private _seeking = _initialTargetPoint vectorDiff _posPrevious;

		{
			private _neighbour = _x;
			// Calculate the separation vector
			if (_neighbour distance _posPrevious < grad_crows_separation_dist) then {
				_separation = _separation vectorAdd (_posPrevious vectorDiff getPos _neighbour);
			};

			// Calculate the alignment vector
			if (_neighbour distance _posPrevious < grad_crows_alignment_dist) then {
				_alignment = _alignment vectorAdd velocity _neighbour;
			};

			// Calculate the cohesion vector
			_cohesion = _cohesion vectorAdd getPos _neighbour;
		} forEach _neighbors;

		// Divide the separation, alignment, and cohesion vectors by the number of _neighbors
		_separation = [_separation, count _neighbors max 1] call BIS_fnc_vectorDivide;
		_alignment = [_alignment, count _neighbors max 1] call BIS_fnc_vectorDivide;
		_cohesion = [_cohesion, count _neighbors max 1] call BIS_fnc_vectorDivide;
		_seeking = [_seeking, count _neighbors max 1] call BIS_fnc_vectorDivide;

		// Normalize the vectors
		_separation = (if (vectorMagnitude _separation > 0) then {vectorNormalized _separation} else {_separation});
		_alignment = (if (vectorMagnitude _alignment > 0) then {vectorNormalized _alignment} else {_alignment}); // vectorNormalized _alignment;
		_cohesion = (if (vectorMagnitude _cohesion > 0) then {vectorNormalized _cohesion} else {_cohesion}); // vectorNormalized _cohesion;
		_seeking = (if (vectorMagnitude _seeking > 0) then {vectorNormalized _seeking} else {_seeking});

		// Add the separation, alignment, and cohesion vectors to the velocity
		private _velNext = _velPrevious vectorAdd (_separation vectorMultiply grad_crows_max_force);
		_velNext = _velNext vectorAdd (_alignment vectorMultiply grad_crows_max_force);
		_velNext = _velNext vectorAdd (_cohesion vectorMultiply grad_crows_max_force);
		_velNext = _velNext vectorAdd (_seeking vectorMultiply grad_crows_max_force);

		// Limit the speed
		if (vectorMagnitude _velNext > grad_crows_max_speed) then {
			_velNext = _velNext vectorMultiply (grad_crows_max_speed / vectorMagnitude _velNext);
		};

		private _posNext = _posPrevious vectorAdd _separation vectorAdd _alignment vectorAdd _cohesion vectorAdd _seeking;
		private _vectorDirNext = _posPrevious vectorFromTo _posNext;
		private _vectorUpNext = vectorNormalized (_vectorDirNext vectorCrossProduct [0, 0, 1]);

		if (_forEachindex == 0) then {
			systemChat str _posNext;
		};
		_velNext vectorAdd [0, 0, 1];

		// safecheck above ground:
		private _positionATL = ASLtoATL _posNext;
		if (_positionATL#2 < 0.1) then {
			_positionATL set [2,0.1];
		};

		// Set the new velocity and orientation of the _boid
		_boid setVelocityTransformation [
			_posPrevious,
			ATLtoASL _positionATL,
			_velPrevious,
			_velNext,
			_vectorDirPrevious,
			_vectorDirNext,
			_vectorUpPrevious,
			_vectorUpNext, 
			linearConversion [_lastSeen, grad_crows_interval, _timeSinceLastSeen, 0, 1]
		];
		_boid setVariable ["grad_crows_lastSeen",_currentTime];
	} forEach _thisFlock;
    
}, 0, [_flock, _initialTargetPoint]] call CBA_fnc_addPerFramehandler;
