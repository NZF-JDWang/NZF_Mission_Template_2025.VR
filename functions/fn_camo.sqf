if (!hasInterface) exitWith {};

// Add a handler to update ghillie status every 1 second
[
    {
        private _player = player;
        
        if !(alive _player) exitWith {
            _player setUnitTrait ["camouflageCoef", 1];
            ["nzf_ghillie_dutyfactor"] call ace_advanced_fatigue_fnc_removeDutyFactor;
            false;
        };

        private _ghillie = goggles _player;
        private _currentCoef = _player getUnitTrait "camouflageCoef";
        
        private _newCoef = switch (_ghillie) do {
            case "nzf_ghillie_2_standalone": { 0.5 };
            case "nzf_ghillie_standalone": { 0.3 };
            default { 0.7 };
        };
        
        if (_currentCoef != _newCoef) then {
            _player setUnitTrait ["camouflageCoef", _newCoef];
            
            if (_newCoef < 0.7) then {
                ["nzf_ghillie_dutyfactor", 2] call ace_advanced_fatigue_fnc_addDutyFactor;
            } else {
                ["nzf_ghillie_dutyfactor"] call ace_advanced_fatigue_fnc_removeDutyFactor;
            };
        };
    }
] call CBA_fnc_addPerFrameHandler;

