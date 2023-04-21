private _allObjects = [
    "garbagebags_f.p3d",
    "garbage_misc.p3d",
    "garbage_metal.p3d"
];


private _debugMarker = {
    params ["_position"];

    private _markerName = str _position;
    private _marker = createMarkerLocal ["seagulls_mrk_debug_" + _markerName,[_position#0,_position#1]];
    _marker setMarkerShapeLocal "ICON";
    _marker setMarkerTypeLocal "hd_join";
};

private _getDimensions = {
    params ["_object"];
    (0 boundingBoxReal _object) params ["_leftBackBottom", "_rightFrontTop"];
    (_rightFrontTop vectorDiff _leftBackBottom) params ["_width", "_length", "_height"];
    [_width, _length, _height]
  
};


private _allMapObjects = nearestTerrainObjects [[worldsize/2, worldSize/2], ["HIDE"], worldSize/2];

private _count = 0;
private _garbageObjects = [];
{
  if ((getModelInfo _x) select 0 in _allObjects) then {
    _count = _count + 1;
    _garbageObjects pushBackUnique _x;
  };

} forEach _allMapObjects;

private _maxCount = 1000;

for "_i" from 1 to _maxCount do {

    private _targetObject = selectRandom _garbageObjects;
    ([_targetObject] call _getDimensions) params ["_width", "_length", "_height"];
   
    private _position = _targetObject getPos [(random _width/2) min (random _length/2), random 360];

    private _positionsOnTopASL = (lineIntersectsSurfaces [
         _position vectorAdd [0, 0, 50],
        _position,
        objNull,
        objNull,
        true,
        -1,
        "VIEW"
    ]);

    if (count _positionsOnTopASL > 0) then {
        private _positionFromArray = (_positionsOnTopASL select 0 select 0);
        systemchat str _positionFromArray;

        private _seagull = createSimpleObject [getMissionPath "seagull_modified6.p3d", _positionFromArray, false]; 
        _seagull setDir (random 360);

        [_positionFromArray] call _debugMarker;

        private _detector = createVehicle ["Sign_Sphere200cm_F", ASLtoAGL _positionFromArray, [], 0, "CAN_COLLIDE"];
        _detector setObjectTextureGlobal [0, "#(rgb,8,8,3)color(1,0,0,1)"];

        

        _detector addEventHandler ["FiredNear", {
            params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];
            private _position = getPos _unit;
            private _positionShooter = getPos _firer;

            {
                if (typeOf _x == "Sign_Sphere200cm_F") then {
                        _x removeAllEventHandlers "FiredNear";
                        _x spawn {
                            sleep random 5;
                            deletevehicle _this;
                        };
                    };
            } forEach nearestObjects [_position, [], 50];


 
            {
                if ((getModelInfo _x) select 0 == "seagull_modified6.p3d") then {
                    private _flyingSeagull = "seagull" camCreate (ASLToAGL getPosASL _x);
                    private _targetWp = _flyingSeagull getPos [random 10, getDir _x];
                    deletevehicle _x;
                    _targetWp set [2, random 20 max 10];
                    private _timeToWp = _flyingSeagull distance2d _targetWp;
                    _flyingSeagull camsetpos _targetWp;
                    _flyingSeagull camcommit _timeToWp;

                    [_flyingSeagull, _positionShooter] spawn {
                        params ["_flyingSeagull", "_positionShooter"];
                        sleep random 2;
                        private _targetWp = (_flyingSeagull getPos [500, (_flyingSeagull getDir _positionShooter) + (180 + random 50 - random 100)]);
                        private _timeToWp = _flyingSeagull distance2d _targetWp;
                        _flyingSeagull camsetpos _targetWp;
                        _flyingSeagull camcommit _timeToWp;
                    };
                };
            } forEach nearestObjects [_position, [], 50];
        }];
    };

};