params ["_crow", "_targetWp", "_speed"];

private _timeToWp = _crow distance _targetWp * vectorMagnitude _speed;

_crow camsetpos _targetWp;
_crow camcommit _timeToWp;