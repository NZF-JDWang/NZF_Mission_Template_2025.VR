/*
 * Author: [NZF] JD Wang
 * Starts the jump sequence by registering all players in the trigger area and setting jumpStart
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call nzf_HALO_fnc_startJump
 */

if (!isServer) exitWith {};

// Show initial message to all players
["<t font='PuristaLight' size='2'>Preparing for takeoff...</t>", -1, -1, 1, 1, 0, 789] remoteExec ["BIS_fnc_dynamicText", 0];

// Start the ramp sequence after 1 second
[{
    [] call nzf_HALO_fnc_startRampSequence;
}, [], 1] call CBA_fnc_waitAndExecute;

// Wait until ramps are fully closed before proceeding
[
    // Condition: check if ramps are closed
    {
        private _bottomClosed = (groundplane animationSourcePhase "ramp_bottom") == 0;
        private _topClosed = (groundplane animationSourcePhase "ramp_top") == 0;
        _bottomClosed && _topClosed
    },
    // Statement: proceed with jump sequence
    {
        // Get all players in the trigger area
        private _playersInTrigger = allPlayers select { _x inArea groundTrigger };

        // Set them as jumpers
        missionNamespace setVariable ["NZF_HALO_jumpers", _playersInTrigger, true];

        // Start the sequence for each player
        {
            [_x] remoteExec ["nzf_HALO_fnc_startJumpSequence", _x];
        } forEach _playersInTrigger;
    }
] call CBA_fnc_waitUntilAndExecute;
