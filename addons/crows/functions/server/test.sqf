// Define constants
BOID_COUNT = 20; // Number of boids
BOID_RADIUS = 5; // Radius within which boids interact
SEPARATION_WEIGHT = 1; // Weight of separation behavior
ALIGNMENT_WEIGHT = 1; // Weight of alignment behavior
COHESION_WEIGHT = 1; // Weight of cohesion behavior
SEEKER_WEIGHT = 0.5; // Weight of seeker behavior
SEEKER_TARGET = [1000, 1000, 0]; // Target position for the seeker
AVOIDANCE_DISTANCE = 5;

// Initialize boids
boids = [];
for (i = 0; i < BOID_COUNT; i++) do {
    boids set [i, call fnc_createBoid];
};

// Main loop
while {true} do {
    // Update boid positions and velocities
    for (i = 0; i < BOID_COUNT; i++) do {
        boid = boids select i;
        [boid, boids] call fnc_updateBoids;
    };

    // Sleep for a short time to avoid busy-waiting
    sleep 0.01;
};

// Function to create a new boid
fnc_createBoid = {
    _position = [random 1000, random 1000, 0];
    _velocity = [random 2, random 2, 0];
    [_position, _velocity];
};

// Function to update a boid's position and velocity
fnc_updateBoids = {
    private ["_boid", "_neighbors", "_separation", "_alignment", "_cohesion", "_seeker", "_acceleration"];

    _boid = _this;
    _neighbors = [_boid, boids] call fnc_findNeighbors;

    // Calculate behaviors
    _separation = [_boid, _neighbors] call fnc_separationBehavior;
    _alignment = [_boid, _neighbors] call fnc_alignmentBehavior;
    _cohesion = [_boid, _neighbors] call fnc_cohesionBehavior;
    _seeker = [_boid] call fnc_seekerBehavior;
    _avoidance = [_boid] call fnc_avoidanceBehaviour;
    _approach = [_boid] call fnc_approachBehavior;

    // Calculate acceleration
    _acceleration = (_separation * SEPARATION_WEIGHT) +
                     (_alignment * ALIGNMENT_WEIGHT) +
                     (_cohesion * COHESION_WEIGHT) +
                     (_seeker * SEEKER_WEIGHT) +
                     (_avoidance * AVOIDANCE_DISTANCE);

    // Update velocity and position
    _boid set [1, _boid select 1 + _acceleration];
    _boid set [0, _boid select 0 + _boid select 1];
};

// Function to find neighboring boids within a certain radius
fnc_findNeighbors = {
    private ["_boid", "_boids", "_neighbors"];

    _boid = _this;
    _boids = _this select 1;
    _neighbors = [];

    {
        if (_boid distance2D _x < BOID_RADIUS) then {
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


fnc_approachBehavior = {
    private ["_boid", "_approach", "_targetPosition"];

    _boid = _this select 0;
    _targetPosition = APPROACH_TARGET;
    _approach = _targetPosition - _boid;

    if (vectorMagnitude(_approach) < APPROACH_DISTANCE) then {
        _approach = _approach * (vectorMagnitude(_approach) / APPROACH_DISTANCE);
    } else {
        _approach = _approach * 0.1;
    };

    _approach;
};