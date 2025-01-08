/*
 * Author: [NZF] JD Wang
 * Initializes the HALO system 
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call nzf_HALO_fnc_init
 */

if (!isServer) exitWith {};

// Initialize jump positions array if not already done (server-side only)
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

// Initialize jumpers array
missionNamespace setVariable ["NZF_HALO_jumpers", [], true];

// Add disconnect handler
addMissionEventHandler ["HandleDisconnect", {
    params ["_unit", "_id", "_uid", "_name"];
    
    // Check if disconnected player was a jumper
    private _jumpers = missionNamespace getVariable ["NZF_HALO_jumpers", []];
    if (_unit in _jumpers) then {
        // Remove from jumpers array
        _jumpers = _jumpers - [_unit];
        missionNamespace setVariable ["NZF_HALO_jumpers", _jumpers, true];
        
        // If this was the last jumper, start cleanup
        if (count _jumpers == 0) then {
            [] call nzf_HALO_fnc_cleanupJumpSequence;
        };
    };
    
    // Don't delete the unit
    false
}];

// Setup Ground based Jump Master
jumpmasterground disableAI "ALL";
jumpmasterground attachTo [groundplane, [-1.1,8.8,1.3]];
detach jumpmasterground;
jumpMasterGround setdir (getdir groundplane) +180;

// Setup internal aircraft lights on all clients
[] remoteExec ["nzf_HALO_fnc_setupAircraftLights", 0, true];

[jumpMasterGround, jumpMasterGround] call ace_common_fnc_claim;
private _sphere = "Sign_Sphere10cm_F" createVehicle [0,0,0];
_sphere attachTo [jumpMasterGround, [0,0.2,1.3]];
_sphere setObjectTexture [0, "#(argb,8,8,3)color(0,0,0,0,CA)"];

// Add single Ready to Jump action
private _readyAction = ["ReadyJump", "Ready to Jump", "\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\getin_ca.paa", {
    [] call nzf_HALO_fnc_startJump;
}, {
    count (missionNamespace getVariable ["NZF_HALO_jumpers", []]) == 0
}] call ace_interact_menu_fnc_createAction;

[_sphere, 0, [], _readyAction] call ace_interact_menu_fnc_addActionToObject;

// Create airborne jumpmaster and store it
private _jumpMaster = [] call nzf_HALO_fnc_createJumpMaster;
missionNamespace setVariable ["NZF_HALO_jumpMaster", _jumpMaster, true];
