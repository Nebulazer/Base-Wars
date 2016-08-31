params["_killed", "_killer", ["_bounty", 500]];

if (isPlayer _killed) then {_bounty = _bounty * 2};

_cash = _killer getVariable ["cash", 0];
_balance = _cash + _bounty;
_killer setVariable["cash", _balance, true];
        
(uiNameSpace getVariable "myUI_DollarTitle") ctrlSetText format ["Money: $%1", _balance];