enableSentences false;
grad_civs_diagnostics_showfps = false;
missionnamespace setVariable ["RDFOpen", false, false];
//*******************************************************************
if (missionNamespace getVariable ["nzf_enableIntro", true]) then {
    ["CBA_loadingScreenDone", {
        call NZF_fnc_intro;
    }] call CBA_fnc_addEventHandler;
};
