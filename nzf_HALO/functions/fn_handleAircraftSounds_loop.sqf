params ["_player", "_plane", "_engineSource"];

// Exit if not local player
if (!local _player) exitWith {};

if (!alive _player || isNull _engineSource) exitWith {};
if (_player distance _plane > 100) exitWith {
    deleteVehicle _engineSource;
};

_engineSource say3D ["nzf_engine_int", 100, 1];

[{
    _this call NZF_HALO_fnc_handleAircraftSounds_loop;
}, _this, 4.5] call CBA_fnc_waitAndExecute; 