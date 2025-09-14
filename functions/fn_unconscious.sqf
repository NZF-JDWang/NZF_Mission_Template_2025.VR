/*
 * Function: NZF_fnc_unconscious
 * 
 * Description:
 *     Manages ACRE radio language switching based on player unconsciousness state.
 *     Switches between English and "Unconscious" language when player becomes unconscious.
 *     Handles unit changes, death, and feature camera (Zeus) scenarios.
 * 
 * Parameters:
 *     0: Player <OBJECT> - The player unit to set up unconscious language switching for
 * 
 * Returns:
 *     Nothing
 * 
 * Example:
 *     [player] call NZF_fnc_unconscious;
 * 
 * Author: NZF Mission Template (Based on work by Mike)
 * 
 * Dependencies:
 *     - ACRE2 mod
 *     - CBA_fnc_addEventHandler
 *     - CBA_fnc_addPlayerEventHandler
 *     - ace_unconscious event
 */

params ["_player"];

if (!hasInterface) exitWith {};

// Set languages
["en", "English"] call acre_api_fnc_babelAddLanguageType;
["un", "Unconscious"] call acre_api_fnc_babelAddLanguageType;

// Set spoken
["en"] call acre_api_fnc_babelSetSpokenLanguages;

// Switch language on unconscious toggle
["ace_unconscious", {
    params ["_unit", "_state"];

    if (_unit != ACE_player) exitWith {}; // Ignore if remote unit

    if (_state) then {
        ["un"] call acre_api_fnc_babelSetSpokenLanguages;
    } else {
        ["en"] call acre_api_fnc_babelSetSpokenLanguages;
    };
}] call CBA_fnc_addEventHandler;

// Handle unit change (including death)
["unit", {
    params ["_newUnit", "_oldUnit"];

    if (call CBA_fnc_getActiveFeatureCamera != "") exitWith {}; // Ignore if feature camera active (eg. Zeus)

    if (_newUnit getVariable ["ACE_isUnconscious", false]) then {
        ["un"] call acre_api_fnc_babelSetSpokenLanguages;
    } else {
        ["en"] call acre_api_fnc_babelSetSpokenLanguages;
    };
}, false] call CBA_fnc_addPlayerEventHandler;

// Handle feature camera (eg. Zeus)
["featureCamera", {
    params ["_unit", "_newCamera"];

    if (_newCamera == "" && {ACE_player getVariable ["ACE_isUnconscious", false]}) then {
        ["un"] call acre_api_fnc_babelSetSpokenLanguages;
    } else {
        ["en"] call acre_api_fnc_babelSetSpokenLanguages;
    };
}, false] call CBA_fnc_addPlayerEventHandler;