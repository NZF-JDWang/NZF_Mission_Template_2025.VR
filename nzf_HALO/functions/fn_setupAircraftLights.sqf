/*
 * Author: [NZF] JD Wang
 * Sets up internal red lights in the aircraft
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Array of created light sources
 *
 * Example:
 * private _lights = [] call nzf_HALO_fnc_setupAircraftLights
 */

if (!hasInterface) exitWith {};

private _relativePositions = [
    [-0.00488281,-0.605469,-2.24744],
    [-0.00488281,3.30469,-2.24744],
    [-0.00488281,-4.97363,-2.24744],
    [-0.00488281,-8.39844,-2.24744]
];

// Clean up existing lights if any
{
    deleteVehicle _x;
} forEach (missionNamespace getVariable ["NZF_HALO_aircraftLights", []]);

private _lights = [];

{
    // Create light source locally for each client
    private _light = "#lightpoint" createVehicleLocal [0,0,0];
    _light attachTo [jumpPlane, _x];
    
    // Set up light properties (red military lighting)
    _light setLightColor [1,0,0];
    _light setLightAmbient [0.5,0,0];
    _light setLightBrightness 0.5;
    _light setLightDayLight true;
    _light setLightUseFlare false;
    _light setLightAttenuation [0, 0, 0, 0];  // No attenuation for maximum fill
    _light setLightIntensity 200;
    
    // Store light object
    _lights pushBack _light;
} forEach _relativePositions;

// Store lights in local missionNamespace
missionNamespace setVariable ["NZF_HALO_aircraftLights", _lights];

_lights