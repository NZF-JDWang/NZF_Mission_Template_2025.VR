/*
 * Author: [NZF] JD Wang
 * Handles the jumpmaster's animation sequence after ramp opens
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call nzf_HALO_fnc_jumpMasterSequence
 */

if (!isServer) exitWith {};

private _jumpMaster = missionNamespace getVariable ["NZF_HALO_jumpMaster", objNull];
if (isNull _jumpMaster) exitWith {};

// Reset exit order counter
missionNamespace setVariable ["NZF_HALO_exitOrder", 0, true];

// Detach jumpmaster
detach _jumpMaster;
_jumpMaster disableAI "ANIM";

// Perform salute animation
_jumpMaster playAction "salute";

// After 3 seconds, end salute and change lights
[{
    params ["_jumpMaster"];
    
    // End salute
    _jumpMaster playAction "saluteOff";
    
    // Change lights to green
    remoteExecCall ["nzf_HALO_fnc_setJumpLights", 0, false];
    
    // After 1 second, turn and point
    [{
        params ["_jumpMaster"];
        
        // Detach all players where they are local and start monitoring their exit
        {
            private _player = _x;
            [_player] remoteExec ["detach", _player];
            [_player] remoteExec ["nzf_HALO_fnc_handlePlayerExit", _player];
        } forEach (missionNamespace getVariable ["NZF_HALO_jumpers", []]);
        
        _jumpMaster setDir ((getDir _jumpMaster) + 40);
        _jumpMaster switchMove "Acts_ShowingTheRightWay_loop";
        
    }, [_jumpMaster], 1] call CBA_fnc_waitAndExecute;
    
}, [_jumpMaster], 3] call CBA_fnc_waitAndExecute; 