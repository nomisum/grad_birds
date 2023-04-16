GRAD_CROWS_DEBUG = false;

GRAD_CROWS_STARTLING_DISTANCE = 200;
GRAD_CROWS_COUNT = 13;
GRAD_CROWS_REGISTERSHOTS = false; // for ambient crows


if (GRAD_CROWS_REGISTERSHOTS) then {

	{
		_firedEH = _x addEventHandler ["FiredMan",{
			[getPos (_this select 0)] call GRAD_crows_fnc_registerShot;
		}];
	} forEach allUnits;

};

diag_log "initializing grad crows... done";

systemchat str _this;