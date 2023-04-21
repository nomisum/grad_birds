params ["_flock"];

// Define constants
BOID_COUNT = count _flock; // Number of boids
BOID_RADIUS = 5; // Radius within which boids interact
SEPARATION_WEIGHT = 1; // Weight of separation behavior
ALIGNMENT_WEIGHT = 1; // Weight of alignment behavior
COHESION_WEIGHT = 1; // Weight of cohesion behavior
SEEKER_WEIGHT = 0.5; // Weight of seeker behavior
SEEKER_TARGET = [1000, 1000, 50]; // Target position for the seeker
AVOIDANCE_DISTANCE = 5;

// Initialize boids
private _boids = [];
for "_i" from 1 to BOID_COUNT do {
    _boids set [_i, [_flock, _i] call fnc_createBoid];
};

// Main loop
[{
	params ["_args", "_handle"];
	_args params ["_boid", "_boids"];

	 // Update boid positions and velocities
    for "_i" from 1 to BOID_COUNT do {
        private _boid = _boids select _i;
        [_i, _boid, _boids] call fnc_updateBoids;
    };

	if (BOID_COUNT < 1) then {
		[_handle] call CBA_fnc_removePerFrameHandler;
	};

}, 1, [_boid, _boids]] call CBA_fnc_addPerFrameHandler;


// Function to create a new boid
fnc_createBoid = {
	params ["_flock", "_index"];
    _position = [getPos (_flock select _index)];
    _velocity = [0, random 1, random 3 max 2];
    [_position, _velocity];
};

// Function to update a boid's position and velocity
fnc_updateBoids = {
	params ["_index", "_boid", "_boids"];
    private ["_neighbors", "_separation", "_alignment", "_cohesion", "_seeker", "_acceleration", "_avoidance"];

    _neighbors = [_boid, boids] call fnc_findNeighbors;

    // Calculate behaviors
    _separation = [_boid, _neighbors] call fnc_separationBehavior;
    _alignment = [_boid, _neighbors] call fnc_alignmentBehavior;
    _cohesion = [_boid, _neighbors] call fnc_cohesionBehavior;
    _seeker = [_boid] call fnc_seekerBehavior;
    _avoidance = [_boid] call fnc_avoidanceBehaviour;

    // Calculate acceleration
    _acceleration = (_separation vectorMultiply SEPARATION_WEIGHT) +
                     (_alignment vectorMultiply ALIGNMENT_WEIGHT) +
                     (_cohesion vectorMultiply COHESION_WEIGHT) +
                     (_seeker vectorMultiply SEEKER_WEIGHT) +
                     (_avoidance vectorMultiply AVOIDANCE_DISTANCE);

    // Update velocity and position
	// oid set [1, _boid select 1 + _acceleration];
	_boid params ["_position", "_velocity"];
    _boid set [1, _velocity vectorAdd _acceleration];
    _boid set [0, _position vectorAdd _velocity];

	// actually moving the cam
	private _crowe = _flock select _index;
	_boid params ["_position", "_velocity"];
	[_boid, _position, _velocity] call grad_crows_fnc_crowMoveTo;
};

// Function to find neighboring boids within a certain radius
fnc_findNeighbors = {
    private ["_boid", "_boids", "_neighbors"];

    _boid = _this;
    _boids = _this select 1;
    _neighbors = [];

    {
        if (_boid distance _x < BOID_RADIUS) then {
            _neighbors pushBack _x;
        };
    } forEach _boids;

    _neighbors;
};

// Behavior functions
fnc_separationBehavior = {
    private ["_boid", "_neighbors", "_separation"];

    _boid = _this select 0;
    _neighbors = _this select 1;
    _separation = [0, 0, 0];

    {
        if (_x != _boid) then {
            _distance = _boid distance _x;
            if (_distance < BOID_RADIUS / 2) then {
                _separation = _separation - (_x - _boid);
            };
        };
    } forEach _neighbors;

    _separation;
};

fnc_alignmentBehavior = {
    private ["_boid", "_neighbors", "_alignment", "_averageVelocity"];

    _boid = _this select 0;
    _neighbors = _this select 1;
    _alignment = [0, 0, 0];
    _averageVelocity = [0, 0, 0];

    {
        if (_x != _boid) then {
            _averageVelocity = _averageVelocity + (_x select 1);
        };
    } forEach _neighbors;

    if (count _neighbors > 0) then {
        _averageVelocity = _averageVelocity / count _neighbors;
        _alignment = _averageVelocity - (_boid select 1);
    };

    _alignment;
};

fnc_cohesionBehavior = {
    private ["_boid", "_neighbors", "_cohesion", "_centerOfMass"];

    _boid = _this select 0;
    _neighbors = _this select 1;
    _cohesion = [0, 0, 0];
    _centerOfMass = [0, 0, 0];

    {
        if (_x != _boid) then {
            _centerOfMass = _centerOfMass + _x;
        };
    } forEach _neighbors;

    if (count _neighbors > 0) then {
        _centerOfMass = _centerOfMass / count _neighbors;
        _cohesion = _centerOfMass - _boid;
    };

    _cohesion;
};


fnc_seekerBehavior = {
    private ["_boid", "_seeker", "_seekerDirection"];

    _boid = _this select 0;
    _seeker = SEEKER_TARGET;
    _seekerDirection = _seeker - _boid;

    _seekerDirection;
};

fnc_avoidanceBehaviour = {
    private ["_boid", "_neighbors", "_avoidance", "_avoidanceDirection"];

    _boid = _this select 0;
    _neighbors = _this select 1;
    _avoidance = [0, 0, 0];
    _avoidanceDirection = [0, 0, 0];

    {
        private ["_neighbor", "_distance"];
        _neighbor = _x select 0;
        _distance = _x select 1;
        if (_neighbor != _boid && _distance < AVOIDANCE_DISTANCE) then {
            _avoidanceDirection = _avoidanceDirection - (_neighbor - _boid);
        };
    } forEach _neighbors;

    _avoidance = _avoidanceDirection;
    _avoidance;
};
