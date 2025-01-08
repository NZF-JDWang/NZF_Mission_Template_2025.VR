/*
 * Author: [NZF] JD Wang
 * Changes the aircraft internal lights color to bright green for jump signal
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call nzf_HALO_fnc_setJumpLights
 */

if (!hasInterface) exitWith {};

// Delete old lights and create new ones
{
    deleteVehicle _x;
} forEach (missionNamespace getVariable ["NZF_HALO_aircraftLights", []]);

private _relativePositions = [
    [-0.00488281,-0.605469,-2.24744],
    [-0.00488281,3.30469,-2.24744],
    [-0.00488281,-4.97363,-2.24744],
    [-0.00488281,-8.39844,-2.24744]
];

private _lights = [];

{
    private _light = "#lightpoint" createVehicleLocal [0,0,0];
    _light attachTo [jumpPlane, _x];
    
    // Set up light properties (bright green jump signal)
    _light setLightColor [0,1,0];
    _light setLightAmbient [0,0.5,0];
    _light setLightBrightness 0.8;
    _light setLightDayLight true;
    _light setLightUseFlare false;
    _light setLightAttenuation [0, 0, 0, 0];  // No attenuation for maximum fill
    _light setLightIntensity 300;
    
    _lights pushBack _light;
} forEach _relativePositions;

// Store lights locally
missionNamespace setVariable ["NZF_HALO_aircraftLights", _lights]; 