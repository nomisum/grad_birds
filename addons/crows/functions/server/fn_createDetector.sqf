params ["_flockManager"];

if (!isServer) exitWith {};

private _flock = _flockManager getVariable ["grad_crows_flockOnGround", []];
if (count _flock < 1) exitWith {};


private _crowGround = _flock#0;
private _position = _crowGround getVariable ["grad_crows_positionASL", [0,0,0]];

private _combatDetector = createVehicle ["Sign_Sphere200cm_F", ASLtoAGL _position, [], 0, "CAN_COLLIDE"];
_combatDetector setObjectTextureGlobal [0, "#(rgb,8,8,3)color(0,1,0,0.1)"];
_combatDetector setVariable ["grad_crows_flockManager", _flockManager, true];

_combatDetector addEventHandler ["FiredNear", {
	params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];

	private _flockManager = _unit getVariable ["grad_crows_flockManager", objNull];
	if (isNull _flockManager) exitWith {};

	private _startled = _flockManager getVariable ["grad_crows_startled", false];

	if (!_startled) then {
		[_flockManager] call grad_crows_fnc_triggerStartle;
	};
	
	// update flockmanager that position is unsafe
	if (_startled) then {
		_flockManager setVariable ["grad_crows_lastMovement", CBA_missionTime];
	};
}];

private _unitDetector = createTrigger ["EmptyDetector", getPos _flockManager, false];
_unitDetector setVariable ["grad_crows_flockManager", _flockManager];
_unitDetector setTriggerActivation ["ANYBODY", "PRESENT", true];
_unitDetector setTriggerArea [random 7 max 3, random 7 max 3, 0, true, 250];
_unitDetector setTriggerInterval 2;
_unitDetector setTriggerStatements
[
	"{ _x isKindOf ""Man"" } count thisList > 0",
	"
		private _flockManager = thisTrigger getVariable [""grad_crows_flockManager"", objNull];
		[_flockManager] call grad_crows_fnc_triggerStartle;
		diag_log ""unit detected"";
	",
	""
];


private _vehicleDetector = createTrigger ["EmptyDetector", getPos _flockManager, false];
_vehicleDetector setVariable ["grad_crows_flockManager", _flockManager];
_vehicleDetector setTriggerActivation ["ANYBODY", "PRESENT", true];
_vehicleDetector setTriggerArea [random 15 max 10, random 15 max 10, 0, true, 250];
_vehicleDetector setTriggerInterval 2;
_vehicleDetector setTriggerStatements
[
	"{ _x isKindOf ""LandVehicle"" } count thisList > 0 || { _x isKindOf ""Air"" } count thisList > 0",
	"
		private _flockManager = thisTrigger getVariable [""grad_crows_flockManager"", objNull];
		[_flockManager] call grad_crows_fnc_triggerStartle;
		diag_log ""vehicle detected"";
	",
	""
];

private _detectors = [
		_combatDetector, 
		_unitDetector, 
		_vehicleDetector
	];

_flockManager setVariable ["grad_crows_detectors", _detectors];
