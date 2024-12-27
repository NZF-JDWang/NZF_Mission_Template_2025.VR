if (nzf_template_Groups) then {
	//Initialize player groups (U - menu) now a CBA setting
	["Initialize", [true]] call BIS_fnc_dynamicGroups;
};

// Add UAV terminal to player when they get in a UAV shelter
["rksla3_uav_wkshelter_sa", "InitPost", {
	(_this # 0) addEventHandler ["GetIn", {
    params ["_vehicle", "_role", "_unit", "_turret"];
    _unit linkItem "B_UavTerminal";
	}];

	(_this # 0) addEventHandler ["GetOut", {
    params ["_vehicle", "_role", "_unit", "_turret", "_isEject"];
    _unit unlinkItem "B_UavTerminal";
	}];
// Add ACRE racks to UAV shelters
	(_this # 0) call acre_api_fnc_initVehicleRacks; 
	[(_this # 0), ["ACRE_VRC103", "Control Station Radio", "GCS", false, ["inside"], [], "ACRE_PRC117F", [], []], false, {}] call acre_api_fnc_addRackToVehicle;

	(_this # 0) allowDamage false;
	removeAllWeapons (_this # 0);	
	removeAllItems (_this # 0);
	removeBackpack (_this # 0);
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

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

// Add stretchers to empty ATV
["NDS_6x6_ATV_MIL_EMPTY", "InitPost", {
    params ["_vehicle"];
    private _stretcher = "vtx_stretcher_1" createVehicle [0,0,0];
    _stretcher attachTo [_vehicle, [.4, 1.6, .45]]; 
    private _lid = "plp_cts_MultiboxBigGreyLid" createVehicle [0,0,0];
    _lid setObjectTexture [0, "#(argb,8,8,3)color(0.5,0.5,0,1)"];
    _lid attachTo [_vehicle, [.41, -.43, -0.5]];
 //   _lid enableSimulation false;
    private _stretcher2 = "vtx_stretcher_3" createVehicle [0,0,0];
    _stretcher2 attachTo [_vehicle, [.4, -.45, .6]];
}, nil, nil, true] call CBA_fnc_addClassEventHandler;

// Add burka texture to civilians
addMissionEventHandler ["EntityCreated", {
    params ["_entity"];
    if (_entity isKindOf "CAManBase" && {side _entity == civilian}) then {
        [_entity] call NZF_fnc_setBurkaTexture;
    };
}];