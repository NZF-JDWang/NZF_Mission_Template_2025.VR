params ["_plane"];

// Get the jump plane if not provided
if (isNull _plane) then {
    _plane = missionNamespace getVariable ["jumpPlane", objNull];
};

if (isNull _plane) exitWith {};

private _soundPos = _plane modelToWorld [0,0,0];
playSound3D [getMissionPath "nzf_HALO\sounds\ext_engine_hi.ogg", _plane, false, _soundPos, 5, 1, 300];
playSound3D [getMissionPath "nzf_HALO\sounds\doorwindopen.ogg", _plane, false, _soundPos, 12, 1, 300];

// Check if any players are within range
private _playersInRange = false;
{
    if (_x distance _plane < 300) exitWith { _playersInRange = true };
} forEach allPlayers;

// Continue loop if players are in range
if (_playersInRange) then {
    [{
        _this call NZF_HALO_fnc_handleExteriorSounds_loop;
    }, _this, 4.5] call CBA_fnc_waitAndExecute;
} else {
    // All players have jumped - clean up
    if (isServer) then {
        [_plane] call NZF_HALO_fnc_cleanupJumpMaster;
    };
}; 