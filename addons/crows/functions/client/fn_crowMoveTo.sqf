params ["_crow", "_targetWp", ["_speed", 1]];

private _timeToWp = (_crow distance _targetWp) * _speed;

_crow camsetpos _targetWp;
_crow camcommit _timeToWp;