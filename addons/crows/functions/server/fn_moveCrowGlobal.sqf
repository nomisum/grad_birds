params ["_flyingCrow", "_fromPosAGL", "_toPosAGL", "_duration"];

private _startTime = CBA_missionTime;   
private _endTime = CBA_missionTime + _duration;

private _ascending = _toPosAGL#2 - _fromPosAGL#2 > 2;
private _descending = _fromPosAGL#2 - _toPosAGL#2 > 2;

if (_ascending) then {
	[_flyingCrow,"grad_crowe_flyFast"] remoteExec ["switchmove"];
};

if (_descending) then {
	[_flyingCrow,"grad_crowe_flySlow"] remoteExec ["switchmove"];
};

if (!_ascending && !_descending) then {
	[_flyingCrow,"grad_crowe_flyDefault"] remoteExec ["switchmove"];
};

_flyingCrow setVariable ["grad_crows_moving", true];

private _handle = [{   
	params ["_args","_handle"];   
	_args params ["_flyingCrow", "_startTime", "_endTime", "_fromPosAGL", "_toPosAGL"];   
	
	private _currentVelocity = [0,0,0];   
	private _nextVelocity = [0,0,0];   
	private _currentVectorDir = vectorDir _flyingCrow;   
	private _nextVectorDir = vectorDir _flyingCrow;   
	private _currentVectorUp = vectorUp _flyingCrow;

	if (!alive _flyingCrow) exitWith {
		[_handle] call CBA_fnc_removePerFrameHandler;
	};

	
	// Get the direction vector between the two points
	private _currentVectorDir = _toPosAGL - _fromPosAGL;

	// Calculate a perpendicular vector to the direction vector
	private _perpVector = [_currentVectorDir select 1, -(_currentVectorDir select 0), 0];

	if (_perpVector isEqualTo [0, 0, 0]) then {
		_perpVector = [0, 0, 1];
	};

	// Calculate the final vectorUp direction
	_nextVectorUp = _currentVectorDir vectorCrossProduct _perpVector;

	
	private _path = createVehicle ["Sign_Sphere10cm_F", getPos _flyingCrow, [], 0, "CAN_COLLIDE"];  
	[{ deleteVehicle _this; }, _path, 3] call CBA_fnc_WaitAndExecute;  
	
	_flyingCrow setVelocityTransformation   
	[   
	_fromPosAGL,   
	_toPosAGL,   
	_currentVelocity,   
	_nextVelocity,   
	_currentVectorDir,   
	_nextVectorDir,   
	_currentVectorUp,   
	_nextVectorUp,   
	linearConversion [_startTime, _endTime, CBA_missionTime,0,1,true]   
	];   
}, 0, [_flyingCrow, _startTime, _endTime, _fromPosAGL, _toPosAGL]] call CBA_fnc_addPerFrameHandler;   
     
   
[{   
 	params ["_handle", "_flyingCrow"]; 
	if (isNull _handle) exitWith {};
	[_handle] call CBA_fnc_removePerFrameHandler;   
	// systemChat "removed"; 
	_flyingCrow setVariable ["grad_crows_moving", false];
}, [_handle, _flyingCrow], _duration] call CBA_fnc_waitAndExecute;   
