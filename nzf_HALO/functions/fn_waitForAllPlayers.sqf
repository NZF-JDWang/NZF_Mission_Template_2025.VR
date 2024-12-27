params ["_player", "_plane"];

// Get the jump plane if not provided
if (isNull _plane) then {
    _plane = missionNamespace getVariable ["jumpPlane", objNull];
};

// Get list of GMs, defaulting to empty array if not set
private _gameMasters = missionNamespace getVariable ["nzf_gameMasters", []];

// Wait until all non-GM players are in position
waitUntil {
    // Get all players except GMs that exist
    private _nonGMPlayers = allPlayers select {
        private _player = _x;
        private _varName = vehicleVarName _player;
        _varName != "" && !(_varName in _gameMasters)
    };
    
    private _playersInPosition = _nonGMPlayers select {_x distance _plane < 5};
    
    if (!isDedicated) then {
        diag_log format ["[NZF_HALO] Players in position: %1 of %2", count _playersInPosition, count _nonGMPlayers];
    };
    
    count _playersInPosition == count _nonGMPlayers
}; 