﻿//This script handles all shop crate functionality

params[ "_do", "_this" ];

switch ( _do ) do {

	//********
	// Create crate, setup client and remote DIS and client private 3D icon for crate
	//********
	case "INIT" : {
		private[ "_crate" ];

		//Create crate
		_crate = createVehicle [ "Box_NATO_Ammo_F", [0,0,0], [], 0, "CAN_COLLIDE" ];
		clearItemCargoGlobal _crate;
		clearMagazineCargoGlobal _crate;
		clearWeaponCargoGlobal _crate;
		_crate allowDamage false;
		
		//Set telecache texture
		_crate setObjectTextureGlobal [0,"NEB\Shop\textures\shopCrate_signs_ca.paa"];

		//Store reference to crate on player
		player setVariable [ "NEB_shopCrate", _crate ];
		
		//Load saved crate contents
		[ "LOAD" ] call NEB_fnc_shopCrate;
		
		//Enable DIS of items added by remote/local player once they close the container
		[ "DIS", [ "REMOTE", netId _crate ] ] remoteExec [ "NEB_fnc_shopCrate", 0, format[ "shopCrate_%1", getPlayerUID player ] ];
		
		//Enable DIS of items added to crate by player
		player addEventHandler [ "Put", {
			params[ "_unit", "_container", "_item" ];
			
			_crate = [ "GET" ] call NEB_fnc_shopCrate;
			
			if ( _container isEqualTo _crate ) then {
				_itemType = _item call BIS_fnc_itemType;
				
				switch ( toUpper( _itemType select 0 ) ) do {
					case ( "WEAPON" ) : {
						[ "DIS", "WEAPON" ] call NEB_fnc_shopCrate;
					};
					case ( "EQUIPMENT" ) : {
						if ( toUpper( _itemType select 1 ) in [ "UNIFORM", "VEST", "BACKPACK" ] ) then {
							[ "DIS", "CONTAINER" ] call NEB_fnc_shopCrate;
						};
					};
				};
				
			};
			
		}];
		
		//Setup private 3D icon for players crate
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
		
		_crate
		
	};
	
	//********
	//Function to retrieve a reference to the player crate, if it does not exist then it will be created
	//********
	case "GET" : {
		_crate = player getVariable [ "NEB_shopCrate", objNull ];
		
		if ( isNull _crate ) then {
			_crate = [ "INIT" ] call NEB_fnc_shopCrate;
		};
		
		_crate
	};

	//********
	//Handle showing of players crate
	//********
	case "SHOW" : {
		private[ "_crate" ];
		
		_crate = [ "GET" ] call NEB_fnc_shopCrate;
						
		_crate setVehiclePosition [ player getPos [ 2, getDir player ], [], 0, "CAN_COLLIDE" ];
		
		if ( isObjectHidden _crate ) then {
				[ _crate, false ] remoteExec [ "hideObjectGlobal", 2 ];
		};

		_crate setDir ( getDir player + 90 );

		_crate
	};

	//********
	//Open players crate, used from shop - handles closing of shop UI as well
	//********
	case "OPEN" : {

		_crate = [ "SHOW" ] call NEB_fnc_shopCrate;

		closeDialog 1;

		player action [ "OpenBag", _crate ];
	};

	//********
	//Hide players crate
	//********
	case "HIDE" : {
		_crate = [ "GET" ] call NEB_fnc_shopCrate;

		[ _crate, true ] remoteExec [ "hideObjectGlobal", 2 ];
		
	};
	
	//********
	// Disassemble weapons and containers placed in players crate
	//********
	case "DIS" : {
		params [ "_type", "_this" ];
		
		switch ( toUpper _type ) do {
			
			//Disassemble Weapons
			case "WEAPON" : {
				_crate = [ "GET" ] call NEB_fnc_shopCrate;
				params[ [ "_container", _crate ] ];
				
				_weaponCargoDetails = weaponsItemsCargo _container;
				clearWeaponCargoGlobal _container;
				
				{
					private[ "_secMuzzleMag" ];
					_x params[ "_weapon", "_silencer", "_pointer", "_optic", "_priMuzzleMag", "_bipod" ];
					
					if ( _bipod isEqualType [] ) then {
						_secMuzzleMag = _bipod;
						_bipod = _x select 6;
					}else{
						_secMuzzleMag = [];
					};
					
					_crate addWeaponCargo [ ( _weapon call BIS_fnc_baseWeapon ), 1 ];
					
					{
						if !( _x isEqualTo "" ) then {
							_crate addItemCargo [ _x, 1 ];
						};
					}forEach [ _silencer, _pointer, _optic, _bipod ];
						
					{
						if ( !isNil "_x" && { count _x > 0 } ) then {
							_x params [ "_mag", "_ammo" ];
							systemChat format[ "adding mag - %1", [ _mag, 1, _ammo ] ];
							_crate addMagazineAmmoCargo [ _mag, 1, _ammo ];
						};
					}forEach [ _priMuzzleMag, _secMuzzleMag ];
					
				}forEach _weaponCargoDetails;
			};
			
			//Disassemble containers
			case "CONTAINER" : {
				_crate = [ "GET" ] call NEB_fnc_shopCrate;
				_containers = everyContainer _crate;
				{
					_x params[ "_containerType", "_container" ];
					
					{
						{
							_crate addItemCargo [ _x, 1 ];
						}forEach _x;
					}forEach [
						itemCargo _container,
						backpackCargo _container
					];
					
					{
						_x params[ "_mag", "_ammo" ];
						_crate addMagazineAmmoCargo [ _mag, 1, _ammo ];
					}forEach magazinesAmmoCargo _container;
					
					[ "DIS", [ "WEAPON", _container ] ] call NEB_fnc_shopCrate;
					
					clearMagazineCargoGlobal _container;
					clearItemCargoGlobal _container;
					clearBackpackCargoGlobal _container;
					
				}forEach _containers;
			};
			
			//Disassemble both weapons and containers
			case "ALL" : {
				[ "DIS", "WEAPON" ] call NEB_fnc_shopCrate;
				[ "DIS", "CONTAINER" ] call NEB_fnc_shopCrate;
				
				[ "SAVE" ] call NEB_fnc_shopCrate;
			};
			
			//Handle Disassembly for remote units that place item in player crate
			case "REMOTE" : {
				params[ "_crateID" ];
				
				//Enable dis of items added by remote player when they close the container
				objectFromNetId _crateID addEventHandler [ "ContainerClosed", {
					params[ "_container", "_unit" ];
												
					[ "DIS", "ALL" ] remoteExec [ "NEB_fnc_shopCrate", _container ];
					
				}];
			};
		};
	};
	
	//********
	// Handles loading of player crate at mission start and loading it with saved inventory
	//********
	case "LOAD" : {
		_contents = profileNamespace getVariable [ "NEB_telecache", [] ];
		
		_crate = [ "GET" ] call NEB_fnc_shopCrate;
		
		{
		    switch ( _forEachIndex ) do {
		        case ( 0 ) : {
		            {
		            	_x params[ "_mag", "_ammo" ];
		                _crate addMagazineAmmoCargo [ _mag, 1, _ammo ];
		            }forEach _x;
		        };
		        case ( 1 ) : {
		            {
		                _crate addItemCargo _x;
		            }forEach _x;
		        };
		        case ( 2 ) : {
		            {
		                _crate addWeaponCargo _x;
		            }forEach _x;
		        };
		        case ( 3 ) : {
		            {
		                _crate addBackpackCargo _x;
		            }forEach _x;
		        };
		    };
		}forEach _contents;
	};
	
	//********
	//Handles saving of player crate inventory
	//********
	case "SAVE" : {
		_crate = player getVariable [ "NEB_shopCrate", objNull ];
		
		if !( isNull _crate ) then {
			profileNamespace setVariable[ "NEB_telecache",
				[
					magazinesAmmoCargo _crate,
					itemCargo _crate call BIS_fnc_consolidateArray,
					weaponCargo _crate call BIS_fnc_consolidateArray,
					backpackCargo _crate call BIS_fnc_consolidateArray
				]
			];
		
		};
	};
	
	//Called by server on missionEH HandleDisconnect
	/*case "DISCONNECT" : {
		params[ "_unit", "_id", "_uid", "_name" ];
		
		//Needs testing as a final backup save( most likely to late to remote at this point ) 
		//[ "SAVE" ] remoteExec [ "NEB_fnc_shopCrate", _unit ];
		
	};*/

};