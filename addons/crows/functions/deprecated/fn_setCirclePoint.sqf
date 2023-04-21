/*

	[position player, 50, 0] call GRAD_crows_fnc_setCirclePoint;

*/

params ["_flockPos", "_flockAreaWidth", "_index"];

private _wp0 = [_flockPos, _flockAreaWidth, 00] call BIS_fnc_relPos;
private _wp1 = [_flockPos, _flockAreaWidth, 045] call BIS_fnc_relPos;
private _wp2 = [_flockPos, _flockAreaWidth, 090] call BIS_fnc_relPos;
private _wp3 = [_flockPos, _flockAreaWidth, 135] call BIS_fnc_relPos;
private _wp4 = [_flockPos, _flockAreaWidth, 180] call BIS_fnc_relPos;
private _wp5 = [_flockPos, _flockAreaWidth, 225] call BIS_fnc_relPos;
private _wp6 = [_flockPos, _flockAreaWidth, 270] call BIS_fnc_relPos;
private _wp7 = [_flockPos, _flockAreaWidth, 315] call BIS_fnc_relPos;


private _circlePoint = [_wp0, _wp1, _wp2, _wp3, _wp4, _wp5, _wp6, _wp7];

missionNamespace setVariable [format ["GRAD_crows_circlePointArray_%1", _index], _circlePoint, true];

if (!isMultiplayer) then {
	{
		private _markerstr = createMarker [format ["markername_%1_%2", _x select 0, _x select 1], _x];
		_markerstr setMarkerShape "ICON";
		_markerstr setMarkerType "hd_dot";
		_markerstr setMarkerText (str _forEachIndex);
	} forEach _circlePoint;
};