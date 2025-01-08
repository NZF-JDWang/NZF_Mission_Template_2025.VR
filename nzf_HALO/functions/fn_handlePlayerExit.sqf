/*
 * Author: [NZF] JD Wang
 * Handles the player exit velocity when jumping from the plane
 * First player gets the strongest push, decreasing for subsequent jumpers
 *
 * Arguments:
 * 0: Player <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call nzf_HALO_fnc_handlePlayerExit
 */

params ["_player"];

if (!local _player) exitWith {};

// Initialize exit order tracking if not exists
if (isNil "NZF_HALO_exitOrder") then {
    NZF_HALO_exitOrder = 0;
};

// Get initial position after detachment
private _initialPos = getPosASL _player;
private _hasJumped = false;

// Disable damage immediately after detachment
_player allowDamage false;

// Start monitoring height
[{
    params ["_args", "_handle"];
    _args params ["_player", "_initialPos", "_hasJumped"];
    
    if (!alive _player) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
    };
    
    private _currentPos = getPosASL _player;
    
    // If player hasn't jumped yet, check for 1m drop
    if (!_hasJumped && (_initialPos select 2) - (_currentPos select 2) >= 1) then {
        // Get current exit order and increment for next player
        private _exitOrderNum = NZF_HALO_exitOrder;
        NZF_HALO_exitOrder = NZF_HALO_exitOrder + 1;
        
        // Calculate velocity based on exit order (earlier exits get more velocity)
        private _baseVelocity = 20; // Base forward velocity
        private _velocityMultiplier = 1 - (_exitOrderNum * 0.1); // Decrease by 10% for each subsequent jumper
        private _finalVelocity = _baseVelocity * (_velocityMultiplier max 0.3); // Minimum 30% of base velocity
        
        // Get plane's direction and calculate velocity vector
        private _planeDir = getDir jumpPlane;
        private _velocityX = sin _planeDir * _finalVelocity;
        private _velocityY = cos _planeDir * _finalVelocity;
        
        // Add random side velocity (-2 to 2 m/s)
        private _sideVelocity = (random 4) - 2;
        
        // Calculate perpendicular vector for side velocity
        private _sideX = sin (_planeDir + 90) * _sideVelocity;
        private _sideY = cos (_planeDir + 90) * _sideVelocity;
        
        // Apply velocity
        private _currentVelocity = velocity _player;
        _player setVelocity [
            (_currentVelocity select 0) + _velocityX + _sideX,
            (_currentVelocity select 1) + _velocityY + _sideY,
            (_currentVelocity select 2)
        ];
        
        // Re-enable damage after 2 seconds
        [{
            params ["_player"];
            _player allowDamage true;
        }, [_player], 2] call CBA_fnc_waitAndExecute;
        
        // Mark as jumped
        _args set [2, true];
    };
    
    // If player has jumped, check distance from plane
    if (_hasJumped) then {
        private _distanceFromPlane = _player distance jumpPlane;
        if (_distanceFromPlane > 100) then {
            // Clean up engine sound source if it still exists
            private _engineSource = _player getVariable ["NZF_HALO_engineSource", objNull];
            if (!isNull _engineSource) then {
                private _handle = _player getVariable ["NZF_HALO_soundHandle", -1];
                if (_handle != -1) then {
                    [_handle] call CBA_fnc_removePerFrameHandler;
                };
                deleteVehicle _engineSource;
            };
            
            // Remove player from jumpers array
            private _jumpers = missionNamespace getVariable ["NZF_HALO_jumpers", []];
            _jumpers = _jumpers - [_player];
            missionNamespace setVariable ["NZF_HALO_jumpers", _jumpers, true];
            
            // If this was the last jumper, start cleanup
            if (count _jumpers == 0) then {
                [] remoteExec ["nzf_HALO_fnc_cleanupJumpSequence", 2];
            };
            
            // Stop monitoring this player
            [_handle] call CBA_fnc_removePerFrameHandler;
        };
    };
}, 0, [_player, _initialPos, _hasJumped]] call CBA_fnc_addPerFrameHandler; 