if (nzf_template_Groups) then {
	//Initialize player groups (U - menu) now a CBA setting
	["Initialize", [true]] call BIS_fnc_dynamicGroups;
};
// Initialize NZF arsenal toggle (public, with default OFF)
missionNamespace setVariable ["nzf_arsenalOn", false, true];

// Set the stretchers to be carryable
call NZF_fnc_initStretchers;

// Initialize HALO system if jumpMasterGround exists
if (!isNull (missionNamespace getVariable ["jumpMasterGround", objNull])) then {
    call NZF_HALO_fnc_init;
} else {
    diag_log "[NZF HALO] Warning: jumpMasterGround object not found in mission. HALO system not initialized.";
};

// Add ACRE racks to ATVs
{
    [_x, "InitPost", {
        [
            {
                params ["_vehicle"];
                _vehicle call acre_api_fnc_initVehicleRacks; 
                [_vehicle, ["ACRE_VRC103", "ATV Radio", "Radio", false, ["driver"], [], "", [], []], false, {}] call acre_api_fnc_addRackToVehicle;
            },
            [_this # 0],
            2
        ] call CBA_fnc_waitAndExecute;
    }, nil, nil, true] call CBA_fnc_addClassEventHandler;
} forEach ["NDS_6x6_ATV_MIL_EMPTY", "NDS_6x6_ATV_MIL2", "NDS_6x6_ATV_MIL"];


// Add burka texture to civilians
addMissionEventHandler ["EntityCreated", {
    params ["_entity"];
    if (_entity isKindOf "CAManBase" && 
        {side _entity == civilian} && 
        {uniform _entity == "U_C_Burka_2_Woman"}) then {
        [_entity] call NZF_fnc_setBurkaTexture;
    };
}];