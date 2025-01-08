/*
 * Author: [NZF] JD Wang
 * Opens the ramp of the jump plane and starts the jump sequence
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call nzf_HALO_fnc_openRamp
 */

if (!isServer) exitWith {};

// Play ramp and door opening sounds globally with increased range
jumpPlane say3D ["nzf_ramp_open", 300, 1];
jumpPlane say3D ["nzf_door_open", 1000, 1];

// Start external engine sound loop
[{
    params ["_args", "_handle"];
    
    private _jumpers = missionNamespace getVariable ["NZF_HALO_jumpers", []];
    if (count _jumpers == 0) exitWith {
        [_handle] call CBA_fnc_removePerFrameHandler;
    };
    
    jumpPlane say3D ["nzf_engine_ext", 500, 1];
}, 7, []] call CBA_fnc_addPerFrameHandler;

// Animate ramp
jumpPlane animate ["ramp_bottom", 1, 0.7];
jumpPlane animate ["ramp_top", 1, 0.7];

// Fade out internal engine sound for all players after 2 seconds
[{
    {
        private _engineSource = _x getVariable ["NZF_HALO_engineSource", objNull];
        if (!isNull _engineSource) then {
            [_x] remoteExec ["nzf_HALO_fnc_fadeOutInternalSound", _x];
        };
    } forEach (missionNamespace getVariable ["NZF_HALO_jumpers", []]);
}, [], 2] call CBA_fnc_waitAndExecute;

// After ramp is fully open (5 seconds), start jumpmaster sequence
[{
    [] call nzf_HALO_fnc_jumpMasterSequence;
}, [], 5] call CBA_fnc_waitAndExecute; 