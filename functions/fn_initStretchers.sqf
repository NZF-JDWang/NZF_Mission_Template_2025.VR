/*
 * Function: NZF_fnc_initStretchers
 * 
 * Description:
 *     Initializes stretcher objects with ACE dragging and carrying functionality.
 *     Sets up class event handlers for all stretcher types to make them draggable and carryable.
 * 
 * Parameters:
 *     None
 * 
 * Returns:
 *     Nothing
 * 
 * Example:
 *     [] call NZF_fnc_initStretchers;
 * 
 * Author: NZF Mission Template
 * 
 * Dependencies:
 *     - CBA_fnc_addClassEventHandler
 *     - ace_dragging_fnc_setDraggable
 *     - ace_dragging_fnc_setCarryable
 */

params [];

private _stretcherTypes = ["vtx_stretcher_1", "vtx_stretcher_2", "vtx_stretcher_3"];

{
    [_x, "InitPost", {
        [(_this # 0), false] call ace_dragging_fnc_setDraggable;
        [(_this # 0), true, [0,1,0], 90, true] call ace_dragging_fnc_setCarryable;
    }, nil, nil, true] call CBA_fnc_addClassEventHandler;
} forEach _stretcherTypes;