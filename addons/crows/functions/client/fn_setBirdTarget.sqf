/*
	
	

*/

params ["_pos", "_index"];

missionNamespace setVariable [format ["GRAD_crows_despawnPoint_%1", _index], _pos];

diag_log format ["setting variable %1 to pos %2 and index %3", format ["GRAD_crows_despawnPoint_%1", _index], _pos, _index];