	
params ["_flockManager", "_flock", "_wps"];

systemChat ("crowloop " + str _flockManager);
diag_log ("crowloop " + str _flockManager);

grad_crows_alignment_dist = 5;
grad_crows_max_force = 1;

[{
	params ["_args", "_handle"];
	_args params ["_flockManager", "_flock", "_wps"];

	systemChat str _flockManager;
	diag_log str _flockManager;

	private _startled = _flockManager getVariable ["grad_crows_startled", false];
	private _canLand = !_startled;
	private _hiddenFlock = _flockManager getVariable ["grad_crows_flockOnGround", []];
	private _leadcrow = _flock#0;

	if (_canLand) exitWith {
		{
			private _crow = _x;
			private _hiddenCrow = _hiddenFlock#_forEachIndex;

			[_crow, getPosASL _hiddenCrow, 1] call grad_crows_fnc_crowMoveTo;

			[{
				params ["_crow", "_hiddenCrow"];
				_crow distance _hiddenCrow < 0.2
			},{
				params ["_crow", "_hiddenCrow"];

				deleteVehicle _crow;
				_hiddenCrow hideObject false;

			}, [_crow, _hiddenCrow]] call CBA_fnc_waitUntilAndExecute;
		} forEach _flock;

		[_handle] call CBA_fnc_removePerFrameHandler;
	};

	
	{
		private _crow = _x;
		
		if (_crow == _leadcrow) then {
			private _wpIndex = _crow getVariable ["grad_crows_wpIndex", 0];
			private _maxWps = count _wps;
			private _currentWP = _wps#_wpIndex;

			if (_crow distance _currentWP < 1) then {
				if (_wpIndex >= (_maxWps-1)) then {
					_wpIndex = 0;
				} else {
					_wpIndex = _wpIndex + 1;
					_crow setVariable ["grad_crows_wpIndex", _wpIndex];
				};
			};
				
			[_crow, _currentWP, 1] call grad_crows_fnc_crowMoveTo;
		} else {
		
			// run after lead crow and align to other crows
			{
				private _neighbour = _x;
				private _crowCount = count _flock;

				if (_neighbour != _crow) then {

					private _posPrevious = getPos _leadcrow;
					// Calculate the separation vector - no separation allowed
					private _separation = [0,0,0] vectorAdd (_posPrevious vectorDiff getPos _neighbour);
					private _alignment = [0,0,0];

					// Calculate the alignment vector 
					if (_neighbour distance _posPrevious < grad_crows_alignment_dist) then {
						_alignment = _alignment vectorAdd velocity _neighbour;
					};

					// Calculate the cohesion vector
					private _cohesion = [0,0,0] vectorAdd getPos _neighbour;

					// Divide the separation, alignment, and cohesion vectors by the number of _neighbors
					_separation = [_separation, _crowCount max 1] call BIS_fnc_vectorDivide;
					_alignment = [_alignment, _crowCount max 1] call BIS_fnc_vectorDivide;
					_cohesion = [_cohesion, _crowCount max 1] call BIS_fnc_vectorDivide;

					// Normalize the vectors
					_separation = (if (vectorMagnitude _separation > 0) then {vectorNormalized _separation} else {_separation});
					_alignment = (if (vectorMagnitude _alignment > 0) then {vectorNormalized _alignment} else {_alignment}); // vectorNormalized _alignment;
					_cohesion = (if (vectorMagnitude _cohesion > 0) then {vectorNormalized _cohesion} else {_cohesion}); // vectorNormalized _cohesion;

					// Add the separation, alignment, and cohesion vectors to the velocity
					private _velNext = _velPrevious vectorAdd (_separation vectorMultiply grad_crows_max_force);
					_velNext = _velNext vectorAdd (_alignment vectorMultiply grad_crows_max_force);
					_velNext = _velNext vectorAdd (_cohesion vectorMultiply grad_crows_max_force);

					// Limit the speed
					if (vectorMagnitude _velNext > grad_crows_max_speed) then {
						_velNext = _velNext vectorMultiply (grad_crows_max_speed / vectorMagnitude _velNext);
					};

					private _posNext = _posPrevious vectorAdd _separation vectorAdd _alignment vectorAdd _cohesion;
					[_crow, _posNext, vectorMagnitude _velNext] call grad_crows_fnc_crowMoveTo;
				};
					
			} forEach _flock;
		};

	} forEach _flock;
	
}, 1, [_flockManager, _flock, _crow, _wps]] call CBA_fnc_addPerFrameHandler;

