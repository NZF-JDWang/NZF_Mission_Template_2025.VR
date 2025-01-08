enableSentences false;
grad_civs_diagnostics_showfps = false;
missionnamespace setVariable ["RDFOpen", false, false];

//Set the stretchers to be carrayable
call NZF_fnc_initStretchers;

// Initialize HALO system if jumpMasterGround exists
if (!isNull (missionNamespace getVariable ["jumpMasterGround", objNull])) then {
    call NZF_HALO_fnc_init;
} else {
    if (isServer) then {
        diag_log "[NZF HALO] Warning: jumpMasterGround object not found in mission. HALO system not initialized.";
    };
};

//*******************************************************************

if (missionNamespace getVariable ["nzf_enableIntro", true]) then {
    ["CBA_loadingScreenDone", {
        call NZF_fnc_intro;
    }] call CBA_fnc_addEventHandler;
};
