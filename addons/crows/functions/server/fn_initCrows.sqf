grad_crows_firedTimeout = 60;

call grad_crows_fnc_cacheTerrainObjects; // index map
diag_log "GRAD CROWS - indexing map for grad crows...";

private _flocks = call grad_crows_fnc_createCrows;
diag_log "GRAD CROWS - indexing map for grad crows...done";
