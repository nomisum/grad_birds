params ["_crows", "_relativePositions", "_indexOfFlock"];

{
    [{
        params ["_args", "_handle"];
        _args params ["_leaderCrow", "_singleCrow", "_indexInFlock", "_indexOfFlock", "_relativePositions"];
        
        

        // seperate leader crow from rest
        if (_leaderCrow isEqualTo _singleCrow) then {
                // do nothing here
        } else {
                _targetWp = [_singleCrow, _indexOfFlock] call GRAD_crows_fnc_crowGetWp;
                // move flock crow to leader
                [_singleCrow, _targetWp, _relativePositions, _indexInFlock] call GRAD_crows_fnc_crowMoveTo;
               
                // _helperObject = "Sign_Sphere25cm_Geometry_F" createVehicleLocal (positioncameratoworld _targetWp);
        };
        
        
    },1,[(_crows select 0), _x, _forEachIndex, _indexOfFlock, _relativePositions]] call CBA_fnc_addPerFrameHandler;

} forEach _crows;



[{
    params ["_args", "_handle"];
    _args params ["_indexOfFlock", "_crows"];

    private _leaderCrow = _crows select 0;

    private _circlePointArray = missionNamespace getVariable [format ["GRAD_crows_circlePointArray_%1", _indexOfFlock], []];
    private _circlingIndex = missionNameSpace getVariable ["GRAD_crows_currentCirclingIndex", 0];
    //hintsilent format ["_circlingIndex %1", _circlingIndex];

    // random point to fly to
    // missionNamespace setVariable ["GRAD_crows_currentCirclingIndex", floor (random (count _circlePointArray - 1))];
    
    if (_circlingIndex >= (count _circlePointArray - 1)) then {
        missionNameSpace setVariable ["GRAD_crows_currentCirclingIndex", 0];
    } else {  
        missionNameSpace setVariable ["GRAD_crows_currentCirclingIndex", _circlingIndex + 1];
    };
    

    // get target position
    _targetWp = [_leaderCrow, _indexOfFlock] call GRAD_crows_fnc_crowGetWp;
    [_leaderCrow, _targetWp] call GRAD_crows_fnc_crowMoveTo;
    // systemChat format ["leadercrow making decision to move to %1", _targetWp];

    missionNamespace setVariable [format ["GRAD_crows_circlePoint_%1", _indexOfFlock], _circlePointArray select _circlingIndex];
    

},1,[_indexOfFlock, _crows]] call CBA_fnc_addPerFrameHandler;
