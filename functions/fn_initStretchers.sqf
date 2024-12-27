params [];

private _stretcherTypes = ["vtx_stretcher_1", "vtx_stretcher_2", "vtx_stretcher_3"];

{
    [_x, "InitPost", {
        [(_this # 0), false] call ace_dragging_fnc_setDraggable;
        [(_this # 0), true, [0,1,0], 90, true] call ace_dragging_fnc_setCarryable;
    }, nil, nil, true] call CBA_fnc_addClassEventHandler;
} forEach _stretcherTypes;