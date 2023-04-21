params ["_pos"];

_existingCrows = missionNamespace getVariable ["GRAD_crows_list", []];
_index = count _existingCrows;

diag_log format ["index client %1", _index];

_crows = ["Crowe", _pos, GRAD_CROWS_COUNT, 1, _pos select 2, _index] call GRAD_crows_fnc_crowCreate;

missionNamespace setVariable [format ["GRAD_crows_startlingPoint_%1", _index], [_pos select 0, _pos select 1, 100]];
missionNamespace setVariable [format ["GRAD_crows_density_%1", _index], 15];

_existingCrows append [_crows];
missionNamespace setVariable ["GRAD_crows_list", _existingCrows];