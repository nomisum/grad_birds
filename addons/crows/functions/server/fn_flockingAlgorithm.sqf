// Boids algorithm in SQF
// Author: ChatGPT + nomi in harmonic collab

// Define the _boid object
params ["_flock"];

// Define the parameters
grad_crows_separation_dist = 5;
grad_crows_alignment_dist = 20;
grad_crows_cohesion_dist = 50;
grad_crows_max_speed = 20;
grad_crows_max_force = 10;
grad_crows_interval = 1;

// Define the main loop
[{
	params ["_args", "_handle"];
	_args params ["_flock"];

	{
		private _boid = _x;
		// Get the current position and velocity of the _boid
		private _posPrevious = getPos _boid;
		private _velPrevious = velocity _boid;
		private _vectorUpPrevious = vectorDirVisual _boid;
		private _vectorDirPrevious = vectorDirVisual _boid;

		// Find the neighboring _boids
		private _neighbors = [];
		{
			private _neighbour = _x;
			if (_neighbour != _boid && alive _neighbour && vehicle _neighbour == _boid && (getPos _neighbour distance _posPrevious) < grad_crows_cohesion_dist) then {
				_neighbors pushBack _neighbour;
			}
		} forEach _flock;

		// Calculate the separation, alignment, and cohesion vectors
		private _separation = [0, 0, 0];
		private _alignment = [0, 0, 0];
		private _cohesion = [0, 0, 0];

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
		_separation = [_separation, count _neighbors] call BIS_fnc_vectorDivide;
		_alignment = [_alignment, count _neighbors] call BIS_fnc_vectorDivide;
		_cohesion = [_cohesion, count _neighbors] call BIS_fnc_vectorDivide;

		// Normalize the vectors
		_separation = vectorNormalized _separation;
		_alignment = vectorNormalized _alignment;
		_cohesion = vectorNormalized _cohesion;

		// Add the separation, alignment, and cohesion vectors to the velocity
		private _velNext = _velPrevious vectorAdd (_separation vectorMultiply grad_crows_max_force);
		_velNext = _velPrevious vectorAdd (_alignment vectorMultiply grad_crows_max_force);
		_velNext = _velPrevious vectorAdd (_cohesion vectorMultiply grad_crows_max_force);

		// Limit the speed
		if (_velNext > grad_crows_max_speed) then {
			_velNext = _velPrevious vectorMultiply (grad_crows_max_speed / _velPrevious);
		};

		private _posNext = _posPrevious vectorAdd _separation vectorAdd _alignment vectorAdd _cohesion;
		private _vectorDirNext = _posPrevious vectorFromTo _posNext;
		private _vectorUpNext = vectorNormalized (_vectorDirNext vectorCrossProduct [0, 0, 1]);

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
			grad_crows_interval
		];
	} forEach _flock;
    
}, 0, [_flock]] call CBA_fnc_addPerFramehandler;
