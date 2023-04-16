params ["_object"];

(0 boundingBoxReal _object) params ["_leftBackBottom", "_rightFrontTop"];
(_rightFrontTop vectorDiff _leftBackBottom) params ["_width", "_length", "_height"];

[_width, _length, _height]