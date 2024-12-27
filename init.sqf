enableSentences false;
grad_civs_diagnostics_showfps = false;
missionnamespace setVariable ["RDFOpen", false, false];

//Set the stretchers to be carrayable
call NZF_fnc_initStretchers;

//*******************************************************************

if (missionNamespace getVariable ["nzf_enableIntro", true]) then {
    ["CBA_loadingScreenDone", {
        call NZF_fnc_intro;
    }] call CBA_fnc_addEventHandler;
};
