
private _flocks = call grad_crows_fnc_createCrows;

{
	private _crows = _x;

	{
		private _crowe = _x;

		// lead or "detection" crow
		if (_foreachindex == 0) then {
			private _detector = createVehicle ["Sign_Sphere200cm_F", position _crowe, [], 0, "CAN_COLLIDE"];
        	_detector setObjectTextureGlobal [0, "#(rgb,8,8,3)color(1,0,0,1)"];

			_detector addEventHandler ["Fired", {
				params ["_unit", "_firer", "_distance", "_weapon", "_muzzle", "_mode", "_ammo", "_gunner"];

				private _positionUnit = getPos _unit;
				private _positionFirer = getPos _firer;
				private _flock = _unit getVariable ["grad_crows_flock", []];
				[_positionUnit, _positionFirer, _flock] call grad_crows_fnc_startleFlock;

				deleteVehicle _unit;
			}];

			_detector setVariable ["grad_crows_flock", _crows, true];
		};
	} forEach _crows;
	
} forEach _flocks;

diag_log "initializing grad crows... done";

systemchat str _this;