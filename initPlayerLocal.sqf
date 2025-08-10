if (nzf_template_Groups) then {
    //Initialize player groups (U - menu) now a CBA setting 
    ["InitializePlayer", [player,true]] call BIS_fnc_dynamicGroups; 
};
//*************************************************************************************
// Now make sure if rations are on they don't get hungry or thirsty
if (acex_field_rations_enabled) then {
    [] spawn NZF_fnc_manageGMNeeds;   
};
//*************************************************************************************
//Setup ACE Spectator
[(allPlayers - (missionNamespace getVariable ["nzf_gameMasters", []])), []] call ace_spectator_fnc_updateUnits;
[[1,2], [0]] call ace_spectator_fnc_updateCameraModes;
[[-2,-1], [0,1,2,3,4,5,6,7]] call ace_spectator_fnc_updateVisionModes;
//*************************************************************************************
//Check PJ slots 
if ((player getvariable "role" isEqualTo "PJ") AND (getPlayerUID player in nzf_template_PJs isEqualTo false)) then {endMission "NOT_PJ";};
//Only allow PJ's to access blood crates
Fn_IsRestrictedBoxForPlayerAccess = { 
	params ["_unit", "_box"]; 
    !(player getvariable "role" == "PJ") && typeOf _box == "nzf_NZBloodbox";
    };

player addEventHandler ["InventoryOpened", Fn_IsRestrictedBoxForPlayerAccess];
//*************************************************************************************
//Load default gear
if (player in (missionNamespace getVariable ["nzf_gameMasters", []])) then {
    // Player is a Game Master; do nothing
} else {
    // Player is not a Game Master; apply uniform and remove goggles
    player forceAddUniform selectRandom (parseSimpleArray nzf_template_defaultUniform);
    removeGoggles player;
};

[player, ""] call BIS_fnc_setUnitInsignia;
//Now check if they're in the Unit and if so give them a NZF beret
if (vehicleVarName player isEqualTo "TESTGUY") then {} else 
{
    removeHeadgear player;
    if (squadParams player select 0 select 0 == "NZF") then 
        {
             if (getPlayerUID player in nzf_template_PJs ) then {player addHeadgear "nzf_beret_PJ"} else {player addHeadgear "nzf_beret_black_silver"};
            
        } else {player addHeadgear ""};
    
};
if (getPlayerUID player in nzf_template_PJs) then {removeHeadgear player; player addHeadgear "nzf_beret_PJ"};
//*************************************************************************************
//Make players less visible to the AI 
[] spawn NZF_fnc_camo;
// Setup INCON Undercover (it's ok to leave this even if you're not using the undercover scripts)
if (player getVariable ["isSneaky",false]) then {
    [player] execVM "INC_undercover\Scripts\initUCR.sqf";
};

if (nzf_template_unconsciousMumble) then {
    //Add mubled voices for unconcious players 
	[player] call nzf_fnc_unconscious;
};
//*************************************************************************************
//EventHandlers for respawn
params ["_unit"];

_unit addEventHandler ["Killed", {
    params ["_unit"];
    // Store the player's assigned team
    missionNamespace setVariable [format ["playerAssignedTeam_%1", getPlayerUID _unit], assignedTeam _unit];
    // Existing loadout handling
    Mission_loadout = [getUnitLoadout _unit] call acre_api_fnc_filterUnitLoadout; 
}];

_unit addEventHandler ["Respawn", {
    params ["_unit"];
    // Reassign the player's team if it was previously stored
    private _storedTeam = missionNamespace getVariable format ["playerAssignedTeam_%1", getPlayerUID _unit];
    if (!isNil "_storedTeam") then {
        _unit assignTeam _storedTeam;
        // Optional: Clean up the stored variable
        missionNamespace setVariable [format ["playerAssignedTeam_%1", getPlayerUID _unit], nil];
    };
    // Existing loadout handling
    if (!isNil "Mission_loadout") then {
        _unit setUnitLoadout Mission_loadout;
    };
    [_unit, ""] call BIS_fnc_setUnitInsignia;
}];
//*************************************************************************************
//Add arsenal self interaction to players when they are inside the arsenal trigger
_condition = {
    _player inArea triggerArsenal;
};
_statement = {
    triggerArsenal execVM "arsenal\arsenal.sqf";
     [1, [], {[triggerArsenal,player,false] call ace_arsenal_fnc_openBox;}, {}, "Opening Arsenal"] call ace_common_fnc_progressBar;
};
_action = ["Open Arsenal","Open Arsenal","\a3\ui_f\data\IGUI\Cfg\simpleTasks\types\armor_ca.paa",_statement,_condition] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

["ace_arsenal_displayClosed",{[triggerArsenal, false] call ace_arsenal_fnc_removeBox}] call CBA_fnc_addEventHandler;
triggerArsenal execVM "arsenal\arsenal.sqf";
//*************************************************************************************
// GPS Tracking - Set in CBA settings
if (nzf_template_trackerOn) then {

    _conditionCanOpen = {
        (nzf_template_tracker in items player) && (!(missionnamespace getVariable "RDFOpen"));
    };
    _statement1 = {
        missionnamespace setVariable ["RDFOpen", true]; [trackedObject,0.5,1,1.2,1,{params ["_unit","_target","_updateInterval"];private _reception = 1 - (_unit distance2D _target)/nzf_template_trackerRange;_reception}] call grad_gpsTracker_fnc_openTitle;

    };
    _action1 = ["OpenTracker","Open Tracker","",_statement1,_conditionCanOpen] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions"], _action1] call ace_interact_menu_fnc_addActionToObject;

    _conditionAlreadyOpen = {
    (nzf_template_tracker in items player) && (missionnamespace getVariable "RDFOpen");
    };
    _statement2 = {
        missionnamespace setVariable ["RDFOpen", false]; [grad_gpsTracker_fnc_closeTitle,[],0] call CBA_fnc_waitAndExecute;
    };
    _action2 = ["CloseTracker","Close Tracker","",_statement2,_conditionAlreadyOpen] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions"], _action2] call ace_interact_menu_fnc_addActionToObject;

};

