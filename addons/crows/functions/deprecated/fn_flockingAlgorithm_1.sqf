// Boids algorithm in SQF
// Author: ChatGPT + nomi in harmonic collab

// Define the _boid object
params ["_flock"];

// Define the parameters
/*
grad_crows_separation_dist = 20;
grad_crows_alignment_dist = 20;
grad_crows_cohesion_dist = 50;
grad_crows_max_speed = 0.01;
grad_crows_max_force = 0.01;
grad_crows_interval = 1;
*/

grad_crows_separation_dist = 20; 
grad_crows_alignment_dist = 20; 
grad_crows_cohesion_dist = 50; 
grad_crows_max_speed = 20000; 
grad_crows_max_force = 0.0011; 
grad_crows_interval = 2000;


private _initialTargetPoint = getPosASL (_flock select 0);
_initialTargetPoint set [2, _initialTargetPoint#2+50];

grad_target_point_debug = _initialTargetPoint;



// Define the main loop
[{
	params ["_args", "_handle"];
	_args params ["_thisFlock"];

	{
		private _boid = _x;
		// Get the current position and velocity of the _boid
		private _posPrevious = getPosASL _boid;
		private _velPrevious = velocity _boid;
		private _vectorUpPrevious = vectorUpVisual _boid;
		private _vectorDirPrevious = vectorDirVisual _boid;

		private _currentTime = CBA_missionTime;
		private _lastSeen = _boid getVariable ["grad_crows_lastSeen",CBA_missionTime];
		private _timeSinceLastSeen = _currentTime - _lastSeen;

		// Find the neighboring _boids
		private _neighbors = [];
		{
			private _neighbour = _x;
			if (
				_neighbour != _boid && alive _neighbour && vehicle _neighbour == _boid && 
				(getPosASL _neighbour distance _posPrevious) < grad_crows_cohesion_dist
				) then {
				_neighbors pushBack _neighbour;
			};
		} forEach _thisFlock;

		// Calculate the separation, alignment, and cohesion vectors
		private _separation = [0, 0, 0];
		private _alignment = [0, 0, 0];
		private _cohesion = [0, 0, 0];
		private _seeking = grad_target_point_debug vectorDiff _posPrevious;

		{
			private _neighbour = _x;
			// Calculate the separation vector
			if (_neighbour distance _posPrevious < grad_crows_separation_dist) then {
				_separation = _separation vectorAdd (_posPrevious vectorDiff getPosASL _neighbour);
			};

			// Calculate the alignment vector
			if (_neighbour distance _posPrevious < grad_crows_alignment_dist) then {
				_alignment = _alignment vectorAdd velocity _neighbour;
			};

			// Calculate the cohesion vector
			_cohesion = _cohesion vectorAdd getPosASL _neighbour;
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
			if (_posNext isEqualTo grad_target_point_debug) then {
				systemChat "matching!";
			} else {
				systemChat (str _posNext + " -- " + str grad_target_point_debug);
			};
		};

		// Set the new velocity and orientation of the _boid
		_boid setVelocityTransformation [
			_posPrevious,
			_posNext,
			_velPrevious,
			_velNext,
			_vectorDirPrevious,
			_vectorDirNext,
			_vectorUpPrevious,
			_vectorUpNext, 
			linearConversion [_lastSeen, _lastseen + grad_crows_interval, _timeSinceLastSeen, 0, 1]
		];
		_boid setVariable ["grad_crows_lastSeen",_currentTime];

	} forEach _thisFlock;
    
}, 0, [_flock]] call CBA_fnc_addPerFramehandler;

[{
	private _secondPoint = [grad_target_point_debug#0, grad_target_point_debug#1+20,grad_target_point_debug#2+5];
	private _thirdPoint = [grad_target_point_debug#0-20, grad_target_point_debug#1-20,grad_target_point_debug#2-5];
	grad_target_point_debug = selectRandom [grad_target_point_debug, _secondPoint, _thirdPoint];

	systemChat "setting " + str grad_target_point_debug;
}, 15, []] call CBA_fnc_addPerFrameHandler;