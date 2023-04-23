	
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
	private _crowCount = count _flock;

	if (_canLand) exitWith {
		{
			private _crow = _x;
			private _hiddenCrow = _hiddenFlock#_forEachIndex;

			[_crow, getPos _hiddenCrow, 1] call grad_crows_fnc_crowMoveTo;

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
			private _wpIndex = _leadcrow getVariable ["grad_crows_wpIndex", 0];
			private _maxWps = count _wps;
			private _currentWP = _wps#_wpIndex;

			if (_leadcrow distance2d _currentWP < 3 || speed _leadcrow == 0) then {
				if (_wpIndex >= (_maxWps-1)) then {
					_wpIndex = 0;
				} else {
					_wpIndex = _wpIndex + 1;
				};
				_leadcrow setVariable ["grad_crows_wpIndex", _wpIndex];
			};
				
			[_leadcrow, _currentWP, 1] call grad_crows_fnc_crowMoveTo;
		} else {		
			private _randomPosition = getpos _leadcrow;
			_randomPosition set [0, _randomPosition#0 + random 2 - random 4];
			_randomPosition set [1, _randomPosition#1 + random 2 - random 4];
			_randomPosition set [2, _randomPosition#2 + random 2 - random 4];

			[_crow, _randomPosition, 1] call grad_crows_fnc_crowMoveTo;
		};

	} forEach _flock;
	
}, 1, [_flockManager, _flock, _wps]] call CBA_fnc_addPerFrameHandler;

