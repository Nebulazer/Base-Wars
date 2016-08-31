removeSandbagAction = ["Remove Sandbag", {
    _caller = _this select 1;
    [_this select 0, _this select 2] remoteExec ["removeAction", 0, true];
    _anim = "AinvPknlMstpSnonWnonDnon_medic_1";
    _caller playMove _anim;
    waitUntil {animationState _caller == _anim || !alive _caller};
    waitUntil {animationState _caller != _anim || !alive _caller};
    if (!alive _caller) exitWith {};
    deleteVehicle (_this select 0);
}, [], 5, true, true, "", "'ToolKit' in items _this && (_target distance _this) < 3"];
putSandbagAction = ["Place Sandbag", {
    _caller = _this select 1;
    _anim = "AinvPknlMstpSnonWnonDnon_Putdown_AmovPknlMstpSnonWnonDnon";
    _caller playMove _anim;
    waitUntil {animationState _caller == _anim || !alive _caller};
    waitUntil {animationState _caller != _anim || !alive _caller};
    if (!alive _caller) exitWith {};
    _veh = createVehicle ["Land_BagFence_Long_F", _caller modelToWorld [0, 1.5, 0], [], 0, "CAN_COLLIDE"];
    _veh setDir (getDir _caller);
    [_veh, removeSandbagAction] remoteExec ["addAction", side _caller, true];
}, [], 4, true, true, "", "_this isEqualTo _target && 'ToolKit' in items _this"];
player addAction putSandbagAction;
player addEventHandler ["Respawn", {(_this select 0) addAction putSandbagAction}];