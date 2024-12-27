params ["_player", "_plane", "_jumpOrder"];

if (!local _player) exitWith {};

// Wait until player has fallen at least 1m
waitUntil {
    (getPosATL _player select 2) < ((getPosATL _plane select 2) - 1)
};

// Calculate push force based on jump order (first jumper gets strongest push)
private _baseForce = 33;
private _force = _baseForce - (_jumpOrder * 1.5);
if (_force < 6) then { _force = 6 }; // Doubled minimum force from 3 to 6

// Add some horizontal variation
private _horizontalVariation = (random 2) - 1; // Random value between -1 and 1

// Get plane's direction and calculate velocity vector
private _planeDir = getDir _plane;
private _velX = (sin _planeDir * _force) + _horizontalVariation;
private _velY = (cos _planeDir * _force) + _horizontalVariation;

// Apply the push
private _currentVel = velocity _player;
_player setVelocity [
    (_currentVel select 0) + _velX,
    (_currentVel select 1) + _velY,
    (_currentVel select 2)
];

// Wait until player has fallen 10m before re-enabling damage
waitUntil {
    (getPosATL _player select 2) < ((getPosATL _plane select 2) - 10)
};

// Re-enable damage
_player allowDamage true; 