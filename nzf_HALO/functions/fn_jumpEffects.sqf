#define FADE_TIME 2
#define MESSAGE_DISPLAY_TIME 5
#define MESSAGE_FADE_TIME 1.5
#define SEQUENCE_PAUSE 3
#define FINAL_PAUSE 4

params ["_player", "_plane", "_position"];

// Exit if not local player
if (!local _player) exitWith {};

// Get the jump plane if not provided
if (isNull _plane) then {
    _plane = missionNamespace getVariable ["jumpPlane", objNull];
};

// Disable damage during sequence
_player allowDamage false;

// Start immersive sequence with 2 second fade
0 cutText ["", "BLACK OUT", FADE_TIME];
sleep FADE_TIME;

// Setup interior lights first (local to player) - RED
[_plane, [1, 0, 0]] call NZF_HALO_fnc_setupAircraftLights;
sleep 0.1;

// Start interior engine sounds with fade in
[_player, _plane, "start"] call NZF_HALO_fnc_handleAircraftSounds;

// Attach player to plane at position
_player attachTo [_plane, _position];
_player setDir 0;
_player setUnitPos "UP";
sleep 0.1;

// Initial sequence messages with longer pauses
1 cutText ["<t color='#ffffff' size='2' font='PuristaLight' shadow='0'>Taking off...</t>", "PLAIN", -1, true, true];
sleep MESSAGE_DISPLAY_TIME;
1 cutFadeOut MESSAGE_FADE_TIME;
sleep SEQUENCE_PAUSE;

// Get plane height and convert to feet
private _heightM = round((getPosASL _plane) select 2);
private _heightFt = round(_heightM * 3.28084);  // Convert meters to feet
2 cutText [format ["<t color='#ffffff' size='2' font='PuristaLight' shadow='0'>Climbing to %1m (%2ft)...</t>", _heightM, _heightFt], "PLAIN", -1, true, true];
sleep MESSAGE_DISPLAY_TIME;
2 cutFadeOut MESSAGE_FADE_TIME;
sleep SEQUENCE_PAUSE;

// Wait for all players to be in position
[_player, _plane] call NZF_HALO_fnc_waitForAllPlayers;

// Show approaching message
3 cutText ["<t color='#ffffff' size='2' font='PuristaLight' shadow='0'>Approaching jump point...</t>", "PLAIN", -1, true, true];
sleep MESSAGE_DISPLAY_TIME;
3 cutFadeOut MESSAGE_FADE_TIME;
sleep SEQUENCE_PAUSE;

// Fade back in
"dynamicBlur" ppEffectEnable true;   
"dynamicBlur" ppEffectAdjust [6];   
"dynamicBlur" ppEffectCommit 0;     
"dynamicBlur" ppEffectAdjust [0.0];  
"dynamicBlur" ppEffectCommit 5;  
cutText ["", "BLACK IN", 5];

// Mark this player as ready
_plane setVariable [format ["NZF_playerReady_%1", getPlayerUID _player], true, true];

// Wait before starting ramp sequence
sleep FINAL_PAUSE;

// Only the server should check if all players are ready and start the sequence
if (isServer) then {
    [_plane] spawn NZF_HALO_fnc_checkAllPlayersReady;
};