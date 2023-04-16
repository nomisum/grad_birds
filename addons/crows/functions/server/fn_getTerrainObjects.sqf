private _maxCount = 1000;

private _supportedObjects = [
    "garbagebags_f.p3d",
    "garbage_misc.p3d",
    "garbage_metal.p3d"
];

if (isNil "grad_crows_objects") then {
	grad_crows_objects = _supportedObjects;
} else {
	{
		grad_crows_objects pushBackUnique _x;
	} forEach _supportedObjects;
};


private _allMapObjects = nearestTerrainObjects [[worldsize/2, worldSize/2], ["HIDE"], worldSize/2];

private _count = 0;
private _suitableObjects = [];
{
  if ((getModelInfo _x) select 0 in grad_crows_objects) then {
    _count = _count + 1;
    _suitableObjects pushBackUnique _x;
  };

} forEach _allMapObjects;

_suitableObjects
