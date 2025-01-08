/*
 * Author: [NZF] JD Wang
 * Handles cleanup after all jumpers have exited the plane
 * Resets lights and handles ramp animations
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call nzf_HALO_fnc_cleanupJumpSequence
 */

if (!isServer) exitWith {};

// Reset lights to red for all clients
remoteExecCall ["nzf_HALO_fnc_setupAircraftLights", 0, false];

// Close jumpPlane ramps
jumpPlane animate ["ramp_bottom", 0];
jumpPlane animate ["ramp_top", 0];

// Open groundplane ramps
groundplane animateSource ["ramp_bottom", 1];
groundplane animateSource ["ramp_top", 1]; 