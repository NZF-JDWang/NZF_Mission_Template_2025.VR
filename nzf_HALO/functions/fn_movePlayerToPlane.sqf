params ["_player", "_plane", "_position"];

if (!local _player) exitWith {};

// Start the jump sequence
[_player, _plane, _position] spawn NZF_HALO_fnc_jumpEffects;

true 