   
private _flyingCrowe = "crowe" createVehicle position player;
private _startTime = CBA_missionTime;   
private _endTime = CBA_missionTime + 3;   
  
private _currentPos = getPosASL player;   
private _nextPos = _currentPos vectorAdd [0,0,3];  
  
private _handle = [{   
 params ["_args","_handle"];   
 _args params ["_flyingCrowe", "_startTime", "_endTime", "_currentPos", "_nextPos"];   
   
 private _currentVelocity = [0,0,0];   
 private _nextVelocity = [0,0,0];   
 private _currentVectorDir = vectorDir _flyingCrowe;   
 private _nextVectorDir = vectorDir _flyingCrowe;   
 private _currentVectorUp = vectorUp _flyingCrowe;   
 private _nextVectorUp = vectorUp _flyingCrowe;   

  
 private _path = createVehicle ["Sign_Sphere10cm_F", getPos _flyingCrowe, [], 0, "CAN_COLLIDE"];  
 [{ deleteVehicle _this; }, _path, 3] call CBA_fnc_WaitAndExecute;  
  
 _flyingCrowe setVelocityTransformation   
 [   
  _currentPos,   
  _nextPos,   
  _currentVelocity,   
  _nextVelocity,   
  _currentVectorDir,   
  _nextVectorDir,   
  _currentVectorUp,   
  _nextVectorUp,   
  linearConversion [_startTime, _endTime, CBA_missionTime,0,1,true]   
 ];   
}, 0, [_flyingCrowe, _startTime, _endTime, _currentPos, _nextPos]] call CBA_fnc_addPerFrameHandler;   
     
   
[{   
 params ["_handle", "_flyingCrowe"];   
 [_handle] call CBA_fnc_removePerFrameHandler;   
 systemChat "removed";   
 deleteVehicle _flyingCrowe;   
   
}, [_handle, _flyingCrowe], 3] call CBA_fnc_waitAndExecute;   
  