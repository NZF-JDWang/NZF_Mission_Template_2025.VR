params ["_plane"];

if (!isServer) exitWith {};

private _jumpMasterPosition = [0.882813, 2.39355, -4.87677];

// Create the jump master
private _jumpMaster = createAgent ["C_man_1", [0,0,0], [], 0, "NONE"];
_jumpMaster setVariable ["BIS_enableRandomization", false];

// Remove ACE interactions with correct syntax
[_jumpMaster, _jumpMaster] call ace_common_fnc_claim;

// Comprehensive AI and behavior setup
{
    _jumpMaster disableAI _x;
} forEach ["TARGET", "AUTOTARGET", "MOVE", "FSM", "TEAMSWITCH", "PATH", "COVER", "AUTOCOMBAT", "SUPPRESSION"];

_jumpMaster setBehaviour "CARELESS";
_jumpMaster setCombatMode "BLUE";
_jumpMaster enableDynamicSimulation false;
_jumpMaster allowDamage false;
_jumpMaster enableSimulation true;

// Store position for later use
_jumpMaster setVariable ["NZF_jumpMasterPosition", _jumpMasterPosition, true];

// Remove existing items
removeAllWeapons _jumpMaster;
removeAllItems _jumpMaster;
removeAllAssignedItems _jumpMaster;
removeUniform _jumpMaster;
removeVest _jumpMaster;
removeBackpack _jumpMaster;
removeHeadgear _jumpMaster;
removeGoggles _jumpMaster;

// Add containers and equipment
_jumpMaster forceAddUniform "tfl_pcu_mc_mc_g_uniform";
_jumpMaster addVest "SV2B_LPU23P";
_jumpMaster addHeadgear "HGU68P_MBU14P_Amber";

// Add items
_jumpMaster linkItem "ItemMap";
_jumpMaster linkItem "ItemCompass";
_jumpMaster linkItem "ItemWatch";

// Position the unit relative to plane without attachTo
private _planePos = getPosATL _plane;
private _planeDir = getDir _plane;
private _finalPos = _plane modelToWorld _jumpMasterPosition;
_jumpMaster setPosATL _finalPos;
_jumpMaster setDir (_planeDir + 180);  // Face into cargo area

// Store reference
_plane setVariable ["NZF_jumpMaster", _jumpMaster, true];

// Return the created unit
_jumpMaster 