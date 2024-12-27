params ["_plane", ["_lightColor", [0.5, 0, 0]]];

// Initialize jump master if not already done (server-side)
if (isServer && {isNull (_plane getVariable ["NZF_jumpMaster", objNull])}) then {
    [_plane] call NZF_HALO_fnc_initJumpPlane;
};

// Clean up any existing lights first
for "_i" from 0 to 10 do {  // Using 10 as a safe upper limit
    private _existingLight = _plane getVariable [format ["NZF_light_%1", _i], objNull];
    if (!isNull _existingLight) then {
        deleteVehicle _existingLight;
        _plane setVariable [format ["NZF_light_%1", _i], nil];
    };
};

// Define light positions
private _relativePositions = [
    [-0.00488281,-0.605469,-2.24744],
    [-0.00488281,3.30469,-2.24744],
    [-0.00488281,-4.97363,-2.24744],
    [-0.00488281,-8.39844,-2.24744]
];

// Create lights for each position
{
    private _light = "#lightpoint" createVehicleLocal (getPosATL _plane);
    _light attachTo [_plane, _x];
    
    // Set light properties
    _light setLightColor _lightColor;
    _light setLightAmbient [_lightColor select 0 * 0.2, 0, 0];
    _light setLightIntensity 30;
    _light setLightAttenuation [0.3, 0, 0, 1];
    _light setLightUseFlare false;
    
    // Store light in array for cleanup
    _plane setVariable [format ["NZF_light_%1", _forEachIndex], _light];
} forEach _relativePositions; 