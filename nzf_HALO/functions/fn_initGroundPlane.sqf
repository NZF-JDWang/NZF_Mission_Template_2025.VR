params [["_plane", objNull]];

if (isNull _plane) exitWith {
    diag_log "[NZF_HALO] Error: No ground plane provided for initialization";
    false
};

// Store ground plane reference and set variable
_plane setVariable ["NZF_isGroundPlane", true, true];

// Disable simulation but keep the plane locked in place
_plane allowDamage false;
_plane enableSimulation false;
_plane enableSimulationGlobal false;
_plane setPosASL (getPosASL _plane);
_plane setVectorUp [0,0,1];

// Lock everything
_plane lock true;
_plane lockInventory true;
_plane lockCargo true;
_plane lockDriver true;
_plane lockTurret [[0], true];
removeAllActions _plane;

true