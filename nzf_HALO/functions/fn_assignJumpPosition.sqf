// This function should only be called on the server
if (!isServer) exitWith {
    diag_log format ["[NZF_HALO] Client attempting to remoteExec for player %1", name (_this select 0)];
    [_this select 0] remoteExec ["NZF_HALO_fnc_assignJumpPosition", 2];
};

params ["_player"];
diag_log format ["HALO: Assign Jump Position called for %1", name _player];

// Exit if no player provided
if (isNull _player) exitWith {
    diag_log "[NZF_HALO] Error: No player provided to assignJumpPosition";
    false
};

diag_log format ["[NZF_HALO] Processing jump position for player %1", name _player];

// Initialize mutex if not exists
if (isNil "NZF_HALO_mutex") then {
    NZF_HALO_mutex = false;
};

// Wait if another thread is processing
waitUntil {
    if (NZF_HALO_mutex) then {
        sleep 0.1;
        false
    } else {
        true
    };
};

// Lock the mutex
NZF_HALO_mutex = true;

// Initialize positions array if not already done (server-side only)
if (isNil "NZF_HALO_jumpPositions") then {
    NZF_HALO_jumpPositions = [
        [0.0522461, -0.233098, -4.8768],
        [0.0771484, 0.753719, -4.8768],
        [-0.871094, -0.265324, -4.8768],
        [0.963867, -0.222844, -4.8768],
        [-0.846191, 0.721492, -4.8768],
        [0.0639648, -1.20771, -4.8768],
        [0.98877, 0.763973, -4.8768],
        [-0.859375, -1.23993, -4.8768],
        [0.975586, -1.19745, -4.8768],
        [0.0771484, -2.25458, -4.8768],
        [-0.846191, -2.28681, -4.8768],
        [0.98877, -2.24433, -4.8768],
        [0.0522461, -3.2414, -4.8768],
        [0.963867, -3.23114, -4.8768],
        [-0.871094, -3.27362, -4.8768],
        [-0.019043, -4.23407, -4.8768],
        [0.892578, -4.22382, -4.8768],
        [-0.942383, -4.2663, -4.8768],
        [0.0131836, -5.2707, -4.8768],
        [0.924805, -5.26044, -4.8768],
        [-0.910156, -5.30292, -4.8768],
        [0.0263672, -6.31757, -4.8768],
        [0.937988, -6.30732, -4.8768],
        [-0.896973, -6.3498, -4.8768],
        [0.00146484, -7.30439, -4.8768],
        [0.913086, -7.29413, -4.8768],
        [-0.921875, -7.33661, -4.8768],
        [-0.0698242, -8.29706, -4.8768],
        [0.841797, -8.28681, -4.8768],
        [-0.993164, -8.32929, -4.8768]
    ];
    publicVariable "NZF_HALO_jumpPositions";
};

// Group positions by distance from jump master
private _jumpMasterPos = [0.882813, 2.39355, -4.87677];
private _nearPositions = [];
private _midPositions = [];
private _farPositions = [];

// Categorize positions
{
    private _dist = _x distance _jumpMasterPos;
    if (_dist < 2) then {
        _nearPositions pushBack _x;
    } else {
        if (_dist < 5) then {
            _midPositions pushBack _x;
        } else {
            _farPositions pushBack _x;
        };
    };
} forEach NZF_HALO_jumpPositions;

// Select position preferring far/mid positions first
private _selectedPos = [];
if (count _farPositions > 0) then {
    _selectedPos = selectRandom _farPositions;
} else {
    if (count _midPositions > 0) then {
        _selectedPos = selectRandom _midPositions;
    } else {
        _selectedPos = selectRandom _nearPositions;
    };
};

// Remove selected position from available positions
NZF_HALO_jumpPositions deleteAt (NZF_HALO_jumpPositions find _selectedPos);
publicVariable "NZF_HALO_jumpPositions";

// Release the mutex
NZF_HALO_mutex = false;

// Execute the movement on the player's machine
[_player, jumpPlane, _selectedPos] remoteExec ["NZF_HALO_fnc_movePlayerToPlane", _player];

true 