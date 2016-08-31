waitUntil {alive player};

[] call neb_fnc_core_levelRewards;
[] call fnc_suitAbilities;
[] call NEB_fnc_isSpecialSuit;
(_this select 0) enableStamina false;



