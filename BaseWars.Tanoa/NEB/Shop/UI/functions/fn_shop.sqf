#include "shopMacros.hpp"

disableSerialization;

params[ "_fnc", [ "_this", nil ] ];

switch ( toUpper _fnc ) do {

	//******
	//Initialise starting state of UI
	//******
	case ( "INIT" ) : {
		params[ [ "_shops", NEB_availableShops ] ];

		//Create the UI
		createDialog "NEB_Shop";

		waitUntil { !isNull SHOPDISPLAY };

		//Add each available shop to the dropdown list
		{
			_shopType = _x;
			if ( { _x == _shopType }count _shops > 0 ) then {
				_index = UICTRL( CMB_SHOPTYPE_IDC ) lbAdd _x;
				//If its the first shop in the list set it as the current selected shop
				if ( _shopType == ( _shops select 0 ) ) then {
					UICTRL( CMB_SHOPTYPE_IDC ) lbSetCurSel _index;
				};
			};
		}forEach NEB_availableShops;

		UICTRL( CMB_SHOPTYPE_IDC ) ctrlAddEventHandler [ "LBSelChanged", {
			params[ "_ctrl", "_index" ];
			
			if ( !isNil "NEB_currentShop" && { NEB_currentShop != _ctrl lbText _index } ) then {
				[ "SHOP", _ctrl lbText _index ] call NEB_fnc_shop;
			};
		}];

		[ "SHOP", _shops select 0 ] call NEB_fnc_shop;
	};

	//******
	//Change shops current type - e.g VEHICLE, WEAPON etc
	//******
	case ( "SHOP" ) : {
		params[ "_shopName" ];

		NEB_currentShop = _shopName;

		//Get number of buttons required from shop data
		if ( isNumber( missionConfigFile >> format[ "NEB_%1Data", _shopName ] >> "NEB_shopButtons" ) ) then {
			NEB_shopButtons = getNumber( missionConfigFile >> format[ "NEB_%1Data", _shopName ] >> "NEB_shopButtons" );
		}else{
			//if not specified default to 3
			NEB_shopButtons = 3;
		};

		//Create shop data arrays based on number of butons
		NEB_shopData = [];
		NEB_shopData resize NEB_shopButtons;
		NEB_shopData = NEB_shopData apply{ [] };
	
		//Get the button group layout
		_currentLayout = SHOPLAYOUTS select NEB_shopButtons;
		
		//Hide all the other button layouts
		{
			UICTRL( _x ) ctrlShow false;
		}forEach ( SHOPLAYOUTS - [ _currentLayout ] );
		
		//Make sure new layout is visible
		UICTRL( _currentLayout ) ctrlShow true;

		//Get Data
		[ NEB_currentShop ] call ( missionNamespace getVariable format[ "NEB_fnc_import_%1", NEB_currentShop ] );

		//Set up the UI elements
		[] call ( missionNamespace getVariable format[ "NEB_fnc_UI_%1", NEB_currentShop ] );

		//Set initial shop button
		NEB_currentButton = 0;

		//Update listbox
		[ "LIST" ] call NEB_fnc_Shop;
	};

	//******
	//Change shops current mode - e.g LAND, AIR, SEA etc
	//******
	case ( "MODE" ) : {
		params[ "_button" ];

		//Dont do anything if we are already browsing the same button
		if ( NEB_currentButton isEqualTo _button ) exitWith {};

		//Set shop current button
		NEB_currentButton = _button;

		//Update listbox
		[ "LIST" ] call NEB_fnc_Shop;

	};

	//******
	//Update the listbox
	//******
	case ( "LIST" ) : {
		private[ "_listbox", "_buyButton", "_data", "_cfg", "_index" ];

		_listbox = UICTRL( LB_LIST_IDC );
		_buyButton = UICTRL( BTN_BUY_IDC );

		//Clear info box
		UICTRL( STXT_INFO_IDC ) ctrlSetStructuredText parseText "<br/><t align='center'> - Make a selection - </t><br/>";

		//Clear listbox
		lbClear _listbox;

		//Set listbox selection to nothing
		_listbox lbSetCurSel -1;

		//Disable BUY button
		_buyButton ctrlEnable false;

		//Get the shop data for the current mode we are in LAND, AIR, SEA etc
		_data = NEB_shopData select NEB_currentButton;

		//Fill listbox
		{
			_x params[ "_className", "_level", "_price" ];


			_cfg = {
				if ( isClass ( configFile >> _x >> _className ) ) exitWith {
					( configFile >> _x >> _className )
				};
			}forEach [
				//This list should be enough to cover most class types
				"CfgVehicles",
				"CfgWeapons",
				"CfgGlasses",
				"CfgMagazines",
				"CfgAmmo"
			];

			_index = _listbox lbAdd format[ "%1 - $%2", getText( _cfg >> "displayName" ), _price ];
			_listbox lbSetPicture [ _index, getText( _cfg >> "picture" ) ];
			_listbox lbSetData [ _index, str [ _className, _level ] ];
			_listbox lbSetValue [ _index, _price ];

			//Turn listbox entry red if player is not the correct level
			if ( call NEB_fnc_getPlayerLevel < _level || call NEB_fnc_getPlayerCash < _price ) then {
				_listbox lbSetColor [ _index, [ 1, 0, 0, 0.8 ] ];
				_listbox lbSetSelectColor [ _index, [ 1, 0, 0, 0.8 ] ];
			};

		}forEach _data;

	};

	//******
	//Fill in stats info
	//******
	case ( "INFO" ) : {
		private[ "_cost", "_cfg", "_weapons" ];
		params[ "_ctrl", "_index" ];

		if ( _index isEqualTo -1 ) exitWith {};

		( call compile ( _ctrl lbData _index )) params[ "_className", "_level" ];
		_cost = _ctrl lbValue _index;

		_buyButton = UICTRL( BTN_BUY_IDC );

		if ( call NEB_fnc_getPlayerLevel < _level || call NEB_fnc_getPlayerCash < _cost ) then {
			//Change button Text
			_buyButton ctrlSetText ( [ "Not Enough Money", format[ "Need to be level %1", _level ] ] select ( call NEB_fnc_getPlayerLevel < _level ));
			//Disable BUY button
			_buyButton ctrlEnable false;
		}else{
			//restore BUY Text
			_buyButton ctrlSetText "Buy";
			//Enable BUY button
			_buyButton ctrlEnable true;
		};

		[ _className ] call ( missionNamespace getVariable format[ "NEB_fnc_Info_%1", NEB_currentShop ] );

	};

	//******
	//Handle buying of selected item
	//******
	case ( "BUY" ) : {
		private[ "_listbox", "_index", "_cost", "_emptyPos", "_veh" ];

		_listbox = UICTRL( LB_LIST_IDC );

		_index =  lbCurSel _listbox;
		( call compile ( _listbox lbData _index )) params[ "_className", "_level" ];
		_cost = _listbox lbValue _index;

		[ _className, _cost ] call ( missionNamespace getVariable format[ "NEB_fnc_Buy_%1", NEB_currentShop ] );

	};

	//******
	//Create crate/teleport/open/icon
	//******
	case ( "CRATE" ) : {
		params[ "_do", "_this" ];

		switch ( _do ) do {

			case "GET" : {
				private[ "_crate" ];

				if ( isNull ( player getVariable [ "NEB_shopCrate", objNull ] ) ) then {
					//Create crate
					_crate = createVehicle [ "Box_NATO_Ammo_F", player getPos [ 2, getDir player ], [], 0, "CAN_COLLIDE" ];
					clearItemCargoGlobal _crate;
					clearMagazineCargoGlobal _crate;
					clearWeaponCargoGlobal _crate;
					_crate allowDamage false;

					_crate setObjectTextureGlobal [0,"NEB\Shop\textures\shopCrate_signs_ca.paa"];

					player setVariable [ "NEB_shopCrate", _crate ];

					addMissionEventHandler [ "Draw3D", {
						_crate = player getVariable "NEB_shopCrate";
						if !( isObjectHidden _crate ) then {
							drawIcon3D [
								"\a3\weapons_f\Ammoboxes\data\ui\map_wpnsbox_f_ca.paa",
								[1,1,1,1],
								getPosATLVisual _crate vectorAdd [0,0,1],
								1,
								1,
								0
							];
						};
					}];

				}else{
					_crate = player getVariable "NEB_shopCrate";
					if ( _crate distance player > 4 ) then {
						 _crate setVehiclePosition [ player getPos [ 2, getDir player ], [], 0, "CAN_COLLIDE" ];
					};
					if ( isObjectHidden _crate ) then {
						[ _crate, false ] remoteExec [ "hideObjectGlobal", 2 ];
					};

				};

				_crate setDir ( getDir player + 90 );

				_crate
			};

			case "OPEN" : {
				_crate = player getVariable [ "NEB_shopCrate", objNull ];
				
				_crate = [ "CRATE", "GET" ] call NEB_fnc_shop;

				closeDialog 1;

				player action [ "OpenBag", _crate ];
			};

			case "HIDE" : {
				_crate = player getVariable [ "NEB_shopCrate", objNull ];

				if !( isNull _crate ) then {
					[ _crate, true ] remoteExec [ "hideObjectGlobal", 2 ];
				};
			};

		};

	};
};