/*
 * Function: NZF_fnc_manageGMNeeds
 * 
 * Description:
 *     Manages hunger and thirst levels for Game Masters (Zeus players).
 *     Runs every 60 seconds to reset hunger and thirst to 0 for all registered GMs.
 *     Only functions if ACEX Field Rations is enabled.
 * 
 * Parameters:
 *     None
 * 
 * Returns:
 *     Nothing
 * 
 * Example:
 *     [] call NZF_fnc_manageGMNeeds;
 * 
 * Author: NZF Mission Template
 * 
 * Dependencies:
 *     - CBA_fnc_addPerFrameHandler
 *     - ACEX Field Rations mod
 *     - nzf_gameMasters mission variable
 */

// Create a scheduled execution that runs every 60 seconds
[{
    // Exit if ACEX Field Rations is not enabled
    if !(missionNamespace getVariable ["acex_field_rations_enabled", false]) exitWith {};
    
    private _nzfZeus = missionNamespace getVariable ["nzf_gameMasters", []];
    
    if (!isNil "_nzfZeus" && {_nzfZeus isEqualType []}) then {
        {
            // Convert string to actual object reference
            private _zeusObj = missionNamespace getVariable [_x, objNull];
            
            if (!isNull _zeusObj) then {
                _zeusObj setVariable ["acex_field_rations_thirst", 0, true];
                _zeusObj setVariable ["acex_field_rations_hunger", 0, true];
            };
        } forEach _nzfZeus;
    };
}, 60] call CBA_fnc_addPerFrameHandler;
