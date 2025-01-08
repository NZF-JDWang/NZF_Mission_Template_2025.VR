/*
 * Author: [NZF] JD Wang
 * Handles the jump sequence including player transitions and text displays
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call nzf_HALO_fnc_startJumpSequence
 */

params ["_player"];

// Get random position from jump positions
private _jumpPositions = missionNamespace getVariable ["NZF_HALO_jumpPositions", []];
private _position = selectRandom _jumpPositions;

// Initial fade to black
cutText ["", "BLACK OUT", 2];

// Wait longer for complete fade before moving player and starting sequence
[{
    params ["_player", "_position"];
    
    // Move player first
    _player attachTo [jumpPlane, _position];
    
    // Create sound source and attach to player
    private _engineSource = "#particlesource" createVehicleLocal [0,0,0];
    _engineSource attachTo [_player, [0,0,0]];
    
    // Store engine source for later cleanup
    _player setVariable ["NZF_HALO_engineSource", _engineSource];
    
    // Start with no sound and fade in over 3 seconds
    0 fadeSound 0;
    3 fadeSound 1;
    
    // Start a loop to maintain sound (7 second interval to match sound length)
    private _handle = [{
        params ["_args", "_handle"];
        _args params ["_source", "_player"];
        
        if (isNull _source || {!alive _player}) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };
        
        _source say3D ["nzf_engine_int", 300, 1];
        
    }, 7, [_engineSource, _player]] call CBA_fnc_addPerFrameHandler;
    
    // Store handle for later cleanup
    _player setVariable ["NZF_HALO_soundHandle", _handle];
    
    // Show first text with fade in
    cutText ["<t font='PuristaLight' size='2'>Taking off...</t>", "BLACK FADED", 2, true, true];
    
    // Wait 5 seconds with "Taking off..." text
    [{
        cutText ["", "BLACK FADED", 2];
        
        // Wait 3 seconds with blank screen
        [{
            private _altitude = (getPosASL jumpPlane) select 2;
            private _altitudeMeters = round _altitude;
            private _altitudeFeet = round (_altitude * 3.28084);
            cutText [format ["<t font='PuristaLight' size='2'>Climbing to %1m (%2ft)</t>", _altitudeMeters, _altitudeFeet], "BLACK FADED", 2, true, true];
            
            // Wait 7 seconds with altitude text
            [{
                cutText ["", "BLACK FADED", 2];
                
                // Wait 3 seconds with blank screen
                [{
                    cutText ["<t font='PuristaLight' size='2'>Approaching jump point...</t>", "BLACK FADED", 2, true, true];
                    
                    // Wait 7 seconds with approach text
                    [{
                        cutText ["", "BLACK FADED", 2];
                        
                        // Wait 3 seconds with blank screen, then start final fade in
                        [{
                            cutText ["", "BLACK IN", 5];
                            
                            // Wait 5 seconds after fade in, then open ramp
                            [{
                                // Tell server to open ramp
                                [] remoteExec ["nzf_HALO_fnc_openRamp", 2];
                            }, [], 5] call CBA_fnc_waitAndExecute;
                            
                        }, [], 3] call CBA_fnc_waitAndExecute;
                    }, [], 7] call CBA_fnc_waitAndExecute;
                }, [], 3] call CBA_fnc_waitAndExecute;
            }, [], 7] call CBA_fnc_waitAndExecute;
        }, [], 3] call CBA_fnc_waitAndExecute;
    }, [], 5] call CBA_fnc_waitAndExecute;
}, [_player, _position], 2] call CBA_fnc_waitAndExecute; 