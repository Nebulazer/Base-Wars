deleteVehicle moneyPileB;
hint "You found a secret stash of $5000";
_balance = (player getVariable ["cash", 0]) + 5000;
player setVariable ["cash", _balance, true];
[ [], "fnc_updateStats", player ] call BIS_fnc_MP;
