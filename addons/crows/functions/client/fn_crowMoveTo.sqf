params ["_crow", "_targetWpASL", ["_speed", 1]];

private _timeToWp = (_crow distance _targetWpASL) * _speed;

_crow camsetpos ASLtoAGL _targetWpASL;
_crow camcommit _timeToWp;