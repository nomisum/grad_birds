// params ["_pos"];
private _logic = param [0,objNull,[objNull]];
private _pos = getPos _logic;

private ["_nearest", "_markers", "_marker", "_markersAvailable", "_possibleTrees", "_selectedTree"];

_markers = missionNamespace getVariable ["GRAD_crows_startlingMarkers", []];
_markersAvailable = count _markers > 0;

systemChat "success";

if (_markersAvailable) then {
	_nearest = [_markers, _pos] call BIS_fnc_nearestPosition;
};

if (_markersAvailable && (_pos distance (getMarkerPos _nearest)) < GRAD_CROWS_STARTLING_DISTANCE) exitWith { diag_log format ["already clear of birds"]; };



[{
	_pos = _this select 0;
	_markers = _this select 1;

	_possibleTrees = [];

	{
	    if (str _x find ": t_" > -1) then {
	        _possibleTrees pushBack _x;
	    };
	} forEach nearestObjects [_pos, [], GRAD_CROWS_STARTLING_DISTANCE/2];

	if (count _possibleTrees > 0) then {
		for "_i" from 0 to (ceil (random 6)) do {
			_selectedTree = selectRandom _possibleTrees;
			[_selectedTree modelToWorld boundingCenter _selectedTree] remoteExec ["GRAD_crows_fnc_startleBirds", allPlayers];
			_count = missionNamespace getVariable ["GRAD_crows_serverCount", 0];
			// params are destination and index, set after a delay to let them rise vertically first
			[{[[random worldSize,worldSize + 250,100], _this select 0] remoteExec 
			["GRAD_crows_fnc_setBirdTarget", allPlayers]; }, [_count], 0.5 + random 1] call CBA_fnc_waitAndExecute;

			_count = _count + 1;
			missionNamespace setVariable ["GRAD_crows_serverCount", _count];
			diag_log format ["index client %1", _count];
		};


		// todo make local after debugging
		_marker = createMarkerLocal [format["mrk_grad_crows_%1", toString _pos], _pos];
		_marker setMarkerShapeLocal "ELLIPSE";
		_marker setMarkerSizeLocal [GRAD_CROWS_STARTLING_DISTANCE/2,GRAD_CROWS_STARTLING_DISTANCE/2];
		if (!GRAD_CROWS_DEBUG) then {
			_marker setMarkerAlphaLocal 0;
		};
		_markers append [_marker];
		missionNamespace setVariable ["GRAD_crows_startlingMarkers", _markers];
		// hintsilent format ["%1", _markers];

	} else {
		// diag_log format ["no trees"];
	};
}, [_pos, _markers], random 0.7] call CBA_fnc_waitAndExecute;