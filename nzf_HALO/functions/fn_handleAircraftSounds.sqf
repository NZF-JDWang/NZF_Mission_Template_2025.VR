params ["_player", "_plane", "_state"];

// Exit if not local player
if (!local _player) exitWith {};

// Get the jump plane if not provided
if (isNull _plane) then {
    _plane = missionNamespace getVariable ["jumpPlane", objNull];
};

switch (_state) do {
    case "start": {
        private _engineSource = "#particlesource" createVehicleLocal (getPos _plane);
        _engineSource attachTo [_plane, [0, -2, 1]];
        _player setVariable ["NZF_engineSource", _engineSource];
        
        // Start with volume 0 and fade in (doubled volume from 150 to 300)
        _engineSource say3D ["nzf_engine_int", 300, 0];
        
        // Fade in over 3 seconds and maintain volume
        for "_i" from 0.1 to 1 step 0.1 do {
            [{
                params ["_source", "_volume"];
                _source say3D ["nzf_engine_int", 300, 1];
            }, [_engineSource, _i], _i * 3] call CBA_fnc_waitAndExecute;
        };
        
        // Start a loop to maintain volume
        [{
            params ["_args", "_handle"];
            _args params ["_source", "_player"];
            
            if (isNull _source || {!alive _player}) exitWith {
                [_handle] call CBA_fnc_removePerFrameHandler;
            };
            
            _source say3D ["nzf_engine_int", 300, 1];
            
        }, 3, [_engineSource, _player]] call CBA_fnc_addPerFrameHandler;
        
        // Start the loop after fade-in
        [_player, _plane, _engineSource] spawn NZF_HALO_fnc_handleAircraftSounds_loop;
    };
    
    case "switch_to_exterior": {
        private _oldSource = _player getVariable ["NZF_engineSource", objNull];
        if (!isNull _oldSource) then {
            // Fade out interior over 2 seconds
            for "_i" from 1 to 0.1 step -0.1 do {
                [{
                    params ["_source", "_volume"];
                    _source say3D ["nzf_engine_int", 300 * _volume, 1];
                }, [_oldSource, _i], (1 - _i) * 2] call CBA_fnc_waitAndExecute;
            };
            
            // Delete after fade out
            [{
                params ["_source"];
                deleteVehicle _source;
            }, [_oldSource], 2.5] call CBA_fnc_waitAndExecute;
        };
    };
    
    case "stop": {
        private _engineSource = _player getVariable ["NZF_engineSource", objNull];
        if (!isNull _engineSource) then {
            deleteVehicle _engineSource;
        };
        private _extSource = _player getVariable ["NZF_extEngineSource", objNull];
        if (!isNull _extSource) then {
            deleteVehicle _extSource;
        };
    };
}; 