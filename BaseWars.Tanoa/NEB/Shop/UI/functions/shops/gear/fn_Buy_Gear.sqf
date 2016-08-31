private [ "_allItems" ];
params[ "_className", "_cost" ];

//Remove money
[ _cost ] call NEB_fnc_core_pay;

//Get Crate
_crate = [ "CRATE", "GET" ] call NEB_fnc_shop;

switch( NEB_currentButton ) do {
	//uniform
	case ( 0 ) : {
		if ( uniform player != "" ) then {
			_allItems = uniformItems player;
			_numCrateContainers = count everyContainer _crate;
			_crate addItemCargo [ uniform player, 1 ];
			_newCrateUniform = ( everyContainer _crate ) select _numCrateContainers select 1;
			player forceAddUniform _className;
			{
				if ( player canAddItemToUniform _x ) then {
					uniformContainer player addItemCargoGlobal [ _x, 1 ];
				}else{
					_newCrateUniform addItemCargo [ _x, 1 ];
				};
			}forEach _allItems;	
		}else{
			player forceAddUniform _className;
		};
	};
	
	//vest
	case ( 1 ) : {
		if ( vest player != "" ) then {
			_allItems = vestItems player;
			_numCrateContainers = everyContainer _carte;
			_crate addItemCargo [ vest player, 1 ];
			_newCrateVest = ( everyContainer _crate ) select _numCrateContainers select 1;
			player addVest _className;
			{
				if ( player canAddItemToVest _x ) then {
					vestContainer player addItemCargoGlobal [ _x, 1 ];
				}else{
					_newCrateVest addItemCargo [ _x, 1 ];
				};
			}forEach _allItems;
		}else{
			player addVest _className;
		};
	};
	
	//Backpack
	case ( 2 ) : {
		if ( backpack player != "" ) then {
			_allItems = backpackItems player;
			_numCrateBackpacks = count everyBackpack _crate;
			_crate addBackpackCargo [ backpack player, 1 ];
			_newCrateBackpack = ( everyBackpack _crate ) select _numCrateBackpacks;
			clearItemCargo _newCrateBackpack;
			clearWeaponCargo _newCrateBackpack;
			clearMagazineCargo _newCrateBackpack;
			player addBackpack _className;
			{
				if ( player canAddItemToBackpack _x ) then {
					backpackContainer player addItemCargoGlobal [ _x, 1 ];
				}else{
					_newCrateBackpack addItemCargo [ _x, 1 ];
				};
			}forEach _allItems;
		}else{
			player addBackpack _className;
		};
	
	};
	
	//helmets
	case ( 3 ) : {
		if ( headgear player != "" ) then {
			_crate addItemCargo [ headgear player, 1 ];
		};
		player addHeadgear _className;
	};
	
	//Facewear
	case ( 4 ) : {
		if ( goggles player != "" ) then {
			_crate addItemCargo [ goggles player, 1 ];
		};
		player addGoggles _className;
	};
	
	//NVG
	case ( 5 ) : {
		if ( hmd player != "" ) then {
			_crate addItemCargo [ hmd player, 1 ];
			player unlinkItem hmd player;
		};
		player linkItem _className;
	};
};


if ( count( magazineCargo _crate + weaponCargo _crate + backpackCargo _crate + itemCargo _crate ) > 0 ) then {
	[ "CRATE", "OPEN" ] call NEB_fnc_shop;
}else{
	closeDialog 1;
};