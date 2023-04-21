private _maxCount = 1000;

private _supportedObjects = [
    "garbagebags_f.p3d",
    "garbage_misc.p3d",
    "garbage_metal.p3d",
    "misc_cable_rugs1_ep1.p3d",
    "powerline_01_pole_tall_f.p3d",
    "powerline_01_pole_lamp_f.p3d"
];

if (isNil "grad_crows_objects") then {
	grad_crows_objects = _supportedObjects;
} else {
	{
		grad_crows_objects pushBackUnique _x;
	} forEach _supportedObjects;
};

grad_crows_mapPositions = [];


private _allMapObjects = nearestTerrainObjects [[worldsize/2, worldSize/2], [], worldSize/2];

private _count = 0;
private _suitableObjects = [];
{
  if ((getModelInfo _x) select 0 in grad_crows_objects) then {
    _count = _count + 1;
    _suitableObjects pushBackUnique _x;
  };

} forEach _allMapObjects;

grad_crows_mapPositions = _suitableObjects;
