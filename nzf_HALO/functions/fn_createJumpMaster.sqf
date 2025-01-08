/*
 * Author: [NZF] JD Wang
 * Creates and configures the airborne jumpmaster
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 0: Jumpmaster <OBJECT>
 *
 * Example:
 * private _jumpMaster = [] call nzf_HALO_fnc_createJumpMaster
 */

// Create the airborne jumpmaster 
private _group = createGroup [civilian, true];
private _jumpMaster = _group createUnit ["C_Man_casual_1_F", [0,0,0], [], 0, "NONE"];

// Basic setup
_jumpMaster disableAI "FSM";

// Remove all gear
removeAllWeapons _jumpMaster;
removeAllItems _jumpMaster;
removeAllAssignedItems _jumpMaster;
removeUniform _jumpMaster;
removeVest _jumpMaster;
removeBackpack _jumpMaster;
removeHeadgear _jumpMaster;
removeGoggles _jumpMaster;

// Add specific gear
_jumpMaster forceAddUniform "tfl_pcu_mc_mc_g_uniform";
_jumpMaster addVest "SV2B_LPU23P";
_jumpMaster addHeadgear "HGU68P_MBU14P_Amber";

// Additional AI and behavior setup
{
    _jumpMaster disableAI _x;
} forEach ["TARGET", "AUTOTARGET", "MOVE", "TEAMSWITCH", "PATH", "COVER", "AUTOCOMBAT", "SUPPRESSION"];

// Position the jumpmaster in the plane
_jumpMaster attachTo [jumpPlane, [1, 2.6, -4.9]];

// Set direction after attachment using vectors (facing backward)
_jumpMaster setVectorDirAndUp [[0,-1,0], [0,0,1]];

_jumpMaster 