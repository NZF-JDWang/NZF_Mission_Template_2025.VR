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
