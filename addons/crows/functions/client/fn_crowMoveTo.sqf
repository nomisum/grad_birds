params ["_crow", "_targetWp", ["_relativePositions",[]], ["_indexInFlock", 0]];

/*
if (_indexInFlock isEqualTo 0) then {
	_targetWp set [2, (_targetWp select 2) + random 10 - random 20];
};
*/

if (count _relativePositions > 0) then {
	_targetWp = _targetWp vectorAdd (_relativePositions select _indexInFlock);
	// systemChat "relative Position";
};

_timeToWp = _crow distance2d _targetWp;

_crow camsetpos _targetWp;
_crow camcommit _timeToWp;