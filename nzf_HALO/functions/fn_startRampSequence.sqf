/*
 * Author: [NZF] JD Wang
 * Handles the ramp closing sequence including light changes
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call nzf_HALO_fnc_startRampSequence
 */

if (!isServer) exitWith {};

// Change all lights to red
{
    private _light = missionNamespace getVariable (format ["NZF_HALO_lightPoint_%1", _x]);
    if (!isNull _light) then {
        _light setLightColor [0.8,0,0];
        _light setLightAmbient [0.2,0,0];
        _light setLightBrightness 0.5;
    };
} forEach [1,2,3,4];

// Close the ramp after 2 seconds
[{
	groundplane animateSource  ["ramp_bottom", 0]; 
	groundplane animateSource  ["ramp_top", 0];
    [groundplane, "nzf_ramp_close"] remoteExec ["say3D", 0];
}, [], 2] call CBA_fnc_waitAndExecute; 