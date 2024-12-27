params ["_plane", "_color", "_intensity"];

// Change color for all lights
for "_i" from 0 to 4 do {
    private _light = _plane getVariable [format ["NZF_light_%1", _i], objNull];
    if (!isNull _light) then {
        _light setLightColor _color;
        // For green, use green ambient. For red, use red only
        private _ambient = if (_color select 1 > 0) then {
            [_color select 0 * 0.2, _color select 1 * 0.2, _color select 2 * 0.2]
        } else {
            [_color select 0 * 0.2, 0, 0]
        };
        _light setLightAmbient _ambient;
        _light setLightIntensity _intensity;
    };
}; 