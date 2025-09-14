/*
 * Function: NZF_fnc_camo
 * 
 * Description:
 *     Manages player camouflage coefficient based on ghillie suit equipped.
 *     Uses percentage-based calculations relative to the player's initial camouflage coefficient.
 *     Applies fatigue duty factors for ghillie suits.
 * 
 * Parameters:
 *     None
 * 
 * Returns:
 *     Nothing
 * 
 * Example:
 *     [] call NZF_fnc_camo;
 * 
 * Author: NZF Mission Template
 * 
 * Dependencies:
 *     - CBA_fnc_addPerFrameHandler
 *     - ace_advanced_fatigue_fnc_addDutyFactor
 *     - ace_advanced_fatigue_fnc_removeDutyFactor
 */

if (!hasInterface) exitWith {};

// Store the player's initial camouflage coefficient value
private _initialCamouflageCoef = player getUnitTrait "camouflageCoef";

// Add a handler to update ghillie status every 1 second
[
    {
        private _player = player;
        
        if !(alive _player) exitWith {
            _player setUnitTrait ["camouflageCoef", _initialCamouflageCoef];
            ["nzf_ghillie_dutyfactor"] call ace_advanced_fatigue_fnc_removeDutyFactor;
            false;
        };

        private _ghillie = goggles _player;
        private _currentCoef = _player getUnitTrait "camouflageCoef";
        
        // Calculate new coefficient as percentage of initial value
        private _newCoef = switch (_ghillie) do {
            case "nzf_ghillie_2_standalone": { _initialCamouflageCoef * 0.5 };  // 50% of initial
            case "nzf_ghillie_standalone": { _initialCamouflageCoef * 0.3 };    // 30% of initial
            default { _initialCamouflageCoef * 0.7 };                           // 70% of initial
        };
        
        if (_currentCoef != _newCoef) then {
            _player setUnitTrait ["camouflageCoef", _newCoef];
            
            // Apply fatigue duty factor if wearing ghillie (less than 70% of initial)
            if (_newCoef < (_initialCamouflageCoef * 0.7)) then {
                ["nzf_ghillie_dutyfactor", 2] call ace_advanced_fatigue_fnc_addDutyFactor;
            } else {
                ["nzf_ghillie_dutyfactor"] call ace_advanced_fatigue_fnc_removeDutyFactor;
            };
        };
    }
] call CBA_fnc_addPerFrameHandler;

