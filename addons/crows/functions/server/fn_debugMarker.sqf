params ["_position"];

private _markerName = str _position;
private _marker = createMarkerLocal ["seagulls_mrk_debug_" + _markerName,[_position#0,_position#1]];
_marker setMarkerShapeLocal "ICON";
_marker setMarkerTypeLocal "hd_join";
