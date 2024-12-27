params [["_plane", objNull]];

if (!isServer) exitWith {
    diag_log "[NZF_HALO] Error: Attempting to init jump plane on non-server";
    false
};

if (isNull _plane) exitWith {
    diag_log "[NZF_HALO] Error: No jump plane provided for initialization";
    false
};

// Create jump master immediately
[_plane] call NZF_HALO_fnc_createJumpMaster;

// Store reference
missionNamespace setVariable ["jumpPlane", _plane, true];

true 