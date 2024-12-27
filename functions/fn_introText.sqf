/*
 * Author: [NZF] JD Wang
 * Info text with typewriter effect using CBA
 *
 * Arguments:
 * 0: Array of text lines <ARRAY>
 * 1: Wait time in seconds <NUMBER> (Optional, default: 2)
 *
 * Return Value:
 * None
 *
 * Example:
 * [["Line 1", "Line 2"], 5] call NZF_fnc_introText
 */

if (!hasInterface) exitWith {};

params [
    ["_text", [], [[]]],
    ["_waitTime", 2, [0]]
];

// Initial setup
([] call bis_fnc_rscLayer) cutrsc ["rscInfoText","plain"];

// Convert text array directly to unicode
private _textArrayUnicode = _text apply {toArray _x};

private _textArrayLines = [];
{
    private _line = _x;
    private _textArrayTemp = _line apply {toString [_x]};
    _textArrayLines pushBack _textArrayTemp;
} forEach _textArrayUnicode;

private _textArray = [];
private _emptyArray = [];
private _nArrayTemp = [];
private _n = 0;

{
    private _line = _x;
    _textArray append (_line + ["\n"]);
    {
        _emptyArray pushBack " ";
        _nArrayTemp pushBack _n;
        _n = _n + 1;
    } forEach _x;
    _n = _n + 1;
    _emptyArray pushBack "\n";
} forEach _textArrayLines;

private _finalArray = +_emptyArray;

// Create randomized order
private _nArray = [];
while {count _nArrayTemp > 0} do {
    private _element = selectRandom _nArrayTemp;
    _nArray pushBack _element;
    _nArrayTemp = _nArrayTemp - [_element];
};

// Initial display setup
disableSerialization;
private _display = uiNamespace getVariable "BIS_InfoText";
private _textControl = _display displayCtrl 3101;

private _text = composeText _finalArray;
_textControl ctrlSetText str _text;
_textControl ctrlCommit 0.01;

// Setup the typewriter effect using CBA
[{
    params ["_args", "_handle"];
    _args params ["_finalArray", "_textArray", "_nArray", "_textControl", "_currentIndex", "_waitTime", "_lastPause"];
    
    if (_currentIndex >= count _nArray) exitWith {
        // Start fade out after wait time
        [{
            params ["_finalArray", "_textArray", "_nArray", "_textControl"];
            
            // Start the fade out sequence
            [{
                params ["_args", "_handle"];
                _args params ["_finalArray", "_nArray", "_textControl", "_currentIndex"];
                
                if (_currentIndex >= count _nArray) exitWith {
                    ([] call bis_fnc_rscLayer) cutText ["", "plain"];
                    [_handle] call CBA_fnc_removePerFrameHandler;
                };
                
                _finalArray set [_nArray select _currentIndex, " "];
                private _text = composeText _finalArray;
                _textControl ctrlSetText str _text;
                _textControl ctrlCommit 0.01;
                playSound "ReadoutClick";
                
                _args set [3, _currentIndex + 1];
            }, 0.03, [_finalArray, _nArray, _textControl, 0]] call CBA_fnc_addPerFrameHandler;
            
        }, [_finalArray, _textArray, _nArray, _textControl], _waitTime] call CBA_fnc_waitAndExecute;
        
        [_handle] call CBA_fnc_removePerFrameHandler;
    };
    
    // Check if we're in a pause state
    if (_lastPause > CBA_missionTime) exitWith {};
    
    _finalArray set [_nArray select _currentIndex, _textArray select (_nArray select _currentIndex)];
    private _text = composeText _finalArray;
    _textControl ctrlSetText str _text;
    _textControl ctrlCommit 0.01;
    playSound "ReadoutClick";
    
    // Random slight pause for effect
    if (random 1 > 0.85) then {
        _args set [6, CBA_missionTime + 0.15];  // Set pause until time
        _args set [4, _currentIndex];  // Don't increment this frame
    } else {
        _args set [4, _currentIndex + 1];
    };
    
}, 0.03, [_finalArray, _textArray, _nArray, _textControl, 0, _waitTime, 0]] call CBA_fnc_addPerFrameHandler;