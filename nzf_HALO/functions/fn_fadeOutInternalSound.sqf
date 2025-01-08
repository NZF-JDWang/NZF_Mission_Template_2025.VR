/*
 * Author: [NZF] JD Wang
 * Fades out and cleans up the internal engine sound for a player
 *
 * Arguments:
 * 0: Player <OBJECT>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player] call nzf_HALO_fnc_fadeOutInternalSound
 */

params ["_player"];

if (!local _player) exitWith {};

// Get the sound source and handler
private _engineSource = _player getVariable ["NZF_HALO_engineSource", objNull];
private _handle = _player getVariable ["NZF_HALO_soundHandle", -1];

// Remove the sound loop handler
if (_handle != -1) then {
    [_handle] call CBA_fnc_removePerFrameHandler;
    _player setVariable ["NZF_HALO_soundHandle", nil];
};

// Delete the sound source
if (!isNull _engineSource) then {
    deleteVehicle _engineSource;
    _player setVariable ["NZF_HALO_engineSource", nil];
}; 