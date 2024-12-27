params ["_jumpMaster", ["_action", "salute"]];

if (!isServer) exitWith {};
if (isNull _jumpMaster) exitWith {};

switch (_action) do {
    case "salute": {
        // Ensure proper state
        _jumpMaster setUnitPos "UP";
        _jumpMaster setBehaviour "CARELESS";
        _jumpMaster setCombatMode "BLUE";
        
        // Clear any existing animations and stabilize
        _jumpMaster disableAI "ANIM";
        _jumpMaster switchMove "";
        sleep 0.1;
        
        // Perform salute and hold for 3 seconds
        _jumpMaster playActionNow "salute";
        sleep 3;
        _jumpMaster playActionNow "saluteOff";
    };
    
    case "signal": {
        // Get original position and direction
        private _originalPos = _jumpMaster getVariable ["NZF_jumpMasterPosition", [0.882813, 2.39355, -4.87677]];
        private _originalDir = getDir _jumpMaster;
        
        // First move to the left
        private _angle = _originalDir - 90;
        private _offsetX = sin(_angle) * 0.5;
        private _offsetY = cos(_angle) * 0.5;
        
        // Get the plane and update position
        private _plane = attachedTo _jumpMaster;
        if (!isNull _plane) then {
            private _newPos = [
                (_originalPos select 0) + _offsetX,
                (_originalPos select 1) + _offsetY,
                _originalPos select 2
            ];
            
            detach _jumpMaster;
            _jumpMaster attachTo [_plane, _newPos];
        };
        
        sleep 0.5;
        
        // Rotate and start signal
        _jumpMaster setDir (_originalDir + 40);
        _jumpMaster switchMove "Acts_ShowingTheRightWay_loop";
    };
};