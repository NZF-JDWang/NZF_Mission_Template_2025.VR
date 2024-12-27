params ["_plane"];

if (!isServer) exitWith {};

// Get the jump plane if not provided
if (isNull _plane) then {
    _plane = missionNamespace getVariable ["jumpPlane", objNull];
};

// Get list of GMs
private _gameMasters = missionNamespace getVariable ["nzf_gameMasters", []];

// Wait until all non-GM players are ready
waitUntil {
    private _allReady = true;
    
    // Get all players except GMs
    private _nonGMPlayers = allPlayers select {
        private _player = _x;
        private _varName = vehicleVarName _player;
        _varName != "" && !(_varName in _gameMasters)
    };
    
    // Check if each player has completed their sequence
    {
        private _isReady = _plane getVariable [format ["NZF_playerReady_%1", getPlayerUID _x], false];
        if (!_isReady) then {
            _allReady = false;
        };
    } forEach _nonGMPlayers;
    
    if (!isDedicated) then {
        diag_log format ["[NZF_HALO] Checking player ready status: %1", _allReady];
    };
    
    _allReady
};

// All players are ready, start the ramp sequence
[_plane] spawn nzf_HALO_fnc_startRampSequence;

// Clean up ready status variables
{
    private _varName = format ["NZF_playerReady_%1", getPlayerUID _x];
    _plane setVariable [_varName, nil, true];
} forEach allPlayers; 