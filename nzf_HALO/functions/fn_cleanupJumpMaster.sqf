params ["_plane"];

if (!isServer) exitWith {};

private _jumpMaster = _plane getVariable ["NZF_jumpMaster", objNull];
if (!isNull _jumpMaster) then {
    // Stop animation
    _jumpMaster switchMove "";
    
    // Delete any animation gamelogics
    {
        if (_x isKindOf "Logic" && _x distance _jumpMaster < 10) then {
            deleteVehicle _x;
        };
    } forEach (allMissionObjects "Logic");
    
    // Delete jump master
    deleteVehicle _jumpMaster;
    _plane setVariable ["NZF_jumpMaster", nil, true];
}; 