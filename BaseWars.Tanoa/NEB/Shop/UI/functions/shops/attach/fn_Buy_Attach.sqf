
params[ "_className", "_cost" ];

//Remove money
[ _cost ] call NEB_fnc_core_pay;

//Get Crate
_crate = [ "CRATE", "GET" ] call NEB_fnc_shop;

_crate addItemCargo [ _className, 1 ];
	[ "CRATE", "OPEN" ] call NEB_fnc_shop;

