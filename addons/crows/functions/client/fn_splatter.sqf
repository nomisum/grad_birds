params ["_position"];

private _bloodPoolType = selectRandom 
[
    "BloodSpray_01_New_F",
    "BloodPool_01_Large_New_F",
    "BloodPool_01_Medium_New_F",
    "BloodSplatter_01_Small_New_F"
];

if (_position#2 == 0) then {
	private _bloodPool = _bloodPoolType createVehicleLocal _position;
	_bloodPool setPos _position;
	_bloodPool setDir (random 360);
};



//bloodspray
// private _position = getPos cursorTarget; // for testing

private _source = "#particlesource" createVehicleLocal [0, 0, 0]; 
_source setPos _position; 
_source setParticleParams 
    [ 
        ["\a3\data_f\particleEffects\universal\universal.p3d",16,8,48,0],"", 
        "billboard", 
        0, 
        0.5, 
        [0,0,0.5], 
        [0,0,3], 
        0,10.30,1,-0.1, 
        [0,6], 
        [[0,0,0,1],[0,0,0,0.8],[0,0,0,0.5],[0,0,0,0]], 
        [0.01], 
        0.01, 
        0.08, 
        "", 
        "", 
        _this, 
        0, 
        true, 
        0.5, 
        [[0.5,0,0,1]] 
    ]; 
_source setDropInterval 1; 

 
// meat flowing around 
private _source2 = "#particlesource" createVehicleLocal [0, 0, 0];  
_source2 setPos _position;  
_source2 setParticleCircle [0, [0, 0, 2]];  
_source2 setParticleRandom [0, [1, 1, 1], [2, 2, 2], 0, 0.3, [0, 0, 0, 0.1], 0, 0];  
_source2 setParticleParams [
    ["\A3\data_f\ParticleEffects\Universal\Meat_ca.p3d", 1, 0, 1], "", "SpaceObject", 0.5, 120, 
    [0.1, 0.1, 1], [0, 0, 0], 0.5, 200, 20, 3.75, [0.5,0.5,0.5], [[1, 1, 1, 1], [1, 1, 1, 0.3], [1, 1, 1, 0]], 
    [0.08], 1, 0, "", "", _this,0,true,0.1
];  
_source2 setDropInterval 0.001; 
 
[{ 
    params ["_source"]; 
    deleteVehicle _source; 
}, [_source] ,0.2] call CBA_fnc_waitAndExecute; 
 
[{ 
    params ["_source2"]; 
    deleteVehicle _source2; 
}, [_source2] ,0.2] call CBA_fnc_waitAndExecute;