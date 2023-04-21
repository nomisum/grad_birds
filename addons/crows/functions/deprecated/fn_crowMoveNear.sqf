params ["_crow", "_leadcrow"];

_dis = _crow distance _leadcrow;
_randompos = (getPos _crow) getPos [random _dis, _crow getRelDir _leadcrow]; // random position between bird and lead bird

_time = (_dis);
_crow camsetpos _randompos;
_crow camcommit _time;