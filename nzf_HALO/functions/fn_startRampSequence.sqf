params ["_plane"];

// Get the jump plane if not provided
if (isNull _plane) then {
    _plane = missionNamespace getVariable ["jumpPlane", objNull];
};

#define INITIAL_PAUSE 2
#define RAMP_ANIMATION_TIME 4.4
#define LIGHT_CHANGE_DELAY 3

// Wait for all players to be fully faded in
sleep INITIAL_PAUSE;

// Start the looping exterior sounds
[_plane] spawn nzf_HALO_fnc_handleExteriorSounds_loop;

// Play ramp sound 1 second before animation
private _soundPos = _plane modelToWorld [0,0,0];
playSound3D [getMissionPath "nzf_HALO\sounds\ServoRamp1.ogg", _plane, false, _soundPos, 3, 1, 200];
sleep 1;

// Animate both parts of the ramp
_plane animate ["ramp_top", 1, 0.7];
_plane animate ["ramp_bottom", 1, 0.7];

sleep RAMP_ANIMATION_TIME;

// Get jumpmaster and make him salute just before green light
private _jumpMaster = _plane getVariable ["NZF_jumpMaster", objNull];
if (!isNull _jumpMaster) then {
    _jumpMaster remoteExec ["NZF_HALO_fnc_startJumpMasterSignal", 0];
};

sleep LIGHT_CHANGE_DELAY;

// Change lights to bright green globally
[_plane, [0, 1, 0], 100] remoteExec ["NZF_HALO_fnc_changeLightColor", 0];

// Make jump master move and signal
if (!isNull _jumpMaster) then {
    [_jumpMaster, "signal"] remoteExec ["NZF_HALO_fnc_startJumpMasterSignal", 0];
};

// Detach players
{
    if (local _x) then {
        detach _x;
    };
} forEach allPlayers;

// Initialize jump order tracking
if (isServer) then {
    _plane setVariable ["NZF_jumpOrder", 0, true];
    
    // Start monitoring jumpers
    [_plane] spawn {
        params ["_plane"];
        private _jumpOrder = 0;
        private _initialHeight = getPosATL _plane select 2;
        
        while {true} do {
            {
                if (alive _x && 
                    !(_x getVariable ["NZF_jumpPhysicsApplied", false]) && 
                    (_x distance _plane < 100)) then {
                    
                    _x setVariable ["NZF_jumpPhysicsApplied", true, true];
                    _jumpOrder = _plane getVariable ["NZF_jumpOrder", 0];
                    _plane setVariable ["NZF_jumpOrder", _jumpOrder + 1, true];
                    
                    [_x, _plane, _jumpOrder] remoteExec ["NZF_HALO_fnc_handleJumpPhysics", _x];
                };
            } forEach (allPlayers - (missionNamespace getVariable ["nzf_gameMasters", []]));
            
            sleep 0.1;
        };
    };
};