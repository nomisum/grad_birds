params ["_flyingCrow", "_fromPosAGL", "_toPosAGL", "_duration"];

_duration = _duration * grad_crows_durationMultiplier;

private _fromPosASL = AGLtoASL _fromPosAGL;
private _toPosASL = AGLtoASL _toPosAGL;

private _startTime = CBA_missionTime;   
private _endTime = CBA_missionTime + _duration;

private _ascending = _toPosASL#2 - _fromPosASL#2 > 2;
private _descending = _fromPosASL#2 - _toPosASL#2 > 2;

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
	_args params ["_flyingCrow", "_startTime", "_endTime", "_fromPosASL", "_toPosASL"];   
	
	private _currentVelocity = [0,0,0];   
	private _nextVelocity = [0,0,0];   
	private _currentVectorDir = vectorDir _flyingCrow;   
	private _nextVectorDir = _toPosASL vectorFromTo _fromPosASL;   
	private _currentVectorUp = vectorUp _flyingCrow;
	private _nextVectorUp = vectorUp _flyingCrow;
	private _interval = linearConversion [_startTime, _endTime, CBA_missionTime,0,1,true];
	/*
	if (!alive _flyingCrow) exitWith {
		[_handle] call CBA_fnc_removePerFrameHandler;
	};
	*/
	_controlPointASL = _toPosASL vectorAdd [0, 0, 30];
	_fromControlPointOffset = _controlPointASL vectorDiff _fromPosASL;
	_toControlPointOffset = _toPosASL vectorDiff _controlPointASL;
	
	_flyingCrow setVelocityTransformation   
	[   
		_fromPosASL vectorAdd (_fromControlPointOffset vectorMultiply _interval),
		_controlPointASL vectorAdd (_toControlPointOffset vectorMultiply _interval), 
		_currentVelocity,   
		_nextVelocity,   
		_currentVectorDir,   
		_nextVectorDir,   
		_currentVectorUp,   
		_nextVectorUp,   
		_interval
	];   
}, 0, [_flyingCrow, _startTime, _endTime, _fromPosASL, _toPosASL]] call CBA_fnc_addPerFrameHandler;   
     
   
[{   
 	params ["_handle", "_flyingCrow"]; 
	[_handle] call CBA_fnc_removePerFrameHandler;   
	// systemChat "removed"; 
	if (isNull _flyingCrow) exitWith {};
	_flyingCrow setVariable ["grad_crows_moving", false];
	// private _path = createVehicle ["Sign_Sphere10cm_F", getPos _flyingCrow, [], 0, "CAN_COLLIDE"];  
}, [_handle, _flyingCrow], _duration] call CBA_fnc_waitAndExecute;   
