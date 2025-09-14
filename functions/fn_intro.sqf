/*
 * Function: NZF_fnc_intro
 * 
 * Description:
 *     Creates a cinematic mission introduction sequence with author, mission name, quote,
 *     and location information. Includes music, text effects, and visual transitions.
 *     Manages HUD elements and player simulation during the intro sequence.
 * 
 * Parameters:
 *     None
 * 
 * Returns:
 *     Nothing
 * 
 * Example:
 *     [] call NZF_fnc_intro;
 * 
 * Author: NZF Mission Template
 * 
 * Dependencies:
 *     - missionSetup.hpp
 *     - quotes.hpp
 *     - CBA_fnc_waitAndExecute
 *     - ace_common_fnc_displayTextStructured
 *     - BIS_fnc_cinemaBorder
 *     - NZF_fnc_introText
 */

#include "..\missionSetup.hpp"
#include "..\quotes.hpp"

params [];

if (!hasInterface) exitWith {};

// Clear ACE notifications
["", 999] call ace_common_fnc_displayTextStructured;


private _missionQuote = missionNamespace getVariable ["nzf_missionQuote", ""];

if (_missionQuote isEqualTo "" && isServer) then {
    _missionQuote = if (MISSION_QUOTE isEqualTo "") then {
        selectRandom _nzf_quotes
    } else {
        MISSION_QUOTE
    };
    missionNamespace setVariable ["nzf_missionQuote", _missionQuote, true];
};

waitUntil {
    _missionQuote = missionNamespace getVariable ["nzf_missionQuote", ""];
    !(_missionQuote isEqualTo "")
};

// Utility Functions
private _fnc_getDefaultLocation = {
    private _pos = [];
    private _gms = (entities "VirtualCurator_F");
    if (count _gms > 0) then {
        _pos = getPos (_gms select 0);
    } else {
        _pos = getPos player;
    };
    private _gridPos = mapGridPosition _pos;
    format ["Grid %1", _gridPos]
};

private _fnc_getMapName = {
    private _worldName = worldName;
    private _mapName = getText (configFile >> "CfgWorlds" >> _worldName >> "description");
    if (_mapName == "") then {
        _mapName = _worldName;
    };
    _mapName
};

// Store mission data in variables
private _missionName = MISSION_NAME;
private _missionAuthor = MISSION_AUTHOR;
private _missionLocation = if (MISSION_LOCATION isEqualTo "") then {
    call _fnc_getDefaultLocation
} else {
    MISSION_LOCATION
};
private _missionRegion = if (MISSION_REGION isEqualTo "") then {
    call _fnc_getMapName
} else {
    MISSION_REGION
};

// Initial setup
ace_goggles_effects = 0;
diwako_dui_enable_compass = false;
diwako_dui_namelist = false;
player enableSimulation false;

0 cutText ["", "BLACK", 0.001];

[{
    params ["_args"];
    _args params ["_author", "_missionName", "_quote", "_startLoc", "_region"];
    
    // Start with intro music
    playSound "intro";
    
    // Author text after 6 seconds
    [{
        params ["_author"];
        1 cutText [format ["<t color='#ffffff' size='2.5' font='PuristaMedium' shadow='0'>%1 presents...</t>", _author], "PLAIN", -1, true, true];
    }, [_author], 6] call CBA_fnc_waitAndExecute;
    
    // Clear author text after 10 seconds
    [{
        1 cutFadeOut 0;
    }, [], 10] call CBA_fnc_waitAndExecute;
    
    // Mission name after 12 seconds
    [{
        params ["_missionName"];
        2 cutText [format ["<t color='#ffffff' size='5' font='PuristaMedium' align='center' shadow='0'>%1</t>", _missionName], "PLAIN", -1, true, true];
    }, [_missionName], 12] call CBA_fnc_waitAndExecute;
    
    // Quote after 18 seconds
    [{
        params ["_quote"];
        3 cutText [format ["<t color='#ffffff' size='1' font='PuristaLight' align='center' shadow='0'>%1</t>", _quote], "PLAIN DOWN", 2, true, true];
    }, [_quote], 18] call CBA_fnc_waitAndExecute;
    
    // Fade out texts after 22 seconds
    [{
        2 cutFadeOut 5;
        3 cutFadeOut 3;
    }, [], 22] call CBA_fnc_waitAndExecute;
    
    // Cinema border and effects after 24 seconds
    [{
        [1, 12, true, false] call BIS_fnc_cinemaBorder;
        
        "dynamicBlur" ppEffectEnable true;   
        "dynamicBlur" ppEffectAdjust [6];   
        "dynamicBlur" ppEffectCommit 0;     
        "dynamicBlur" ppEffectAdjust [0.0];  
        "dynamicBlur" ppEffectCommit 5;  
        
        cutText ["", "BLACK IN", 9];
    }, [], 24] call CBA_fnc_waitAndExecute;
    
    // Enable player and HUD after 34 seconds
    [{
        ace_goggles_effects = 2;
        diwako_dui_enable_compass = true;
        diwako_dui_namelist = true;    
        player enableSimulation true;
    }, [], 34] call CBA_fnc_waitAndExecute;
    
    // Final SITREP after 39 seconds
    [{
        params ["_startLoc", "_region"];
        [
            [
                _startLoc,
                _region,           
                "Time: " + (daytime call BIS_fnc_timeToString) + " hours"
            ],
            5
        ] call NZF_fnc_introText;
    }, [_startLoc, _region], 39] call CBA_fnc_waitAndExecute;
    
}, [[_missionAuthor, _missionName, _missionQuote, _missionLocation, _missionRegion]], 3] call CBA_fnc_waitAndExecute;