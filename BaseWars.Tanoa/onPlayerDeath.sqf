//[player] call neb_fnc_core_copyGear;
profileNamespace setVariable ["NEB_PRO_39573_LOADOUT",[]];

	//Crate Saving
	_crate = player getVariable [ "NEB_shopCrate", objNull ];
	if !( isNull _crate ) then {
		profileNamespace setVariable[ "NEB_telecache",
			[
				magazineCargo _crate call BIS_fnc_consolidateArray,
				itemCargo _crate call BIS_fnc_consolidateArray,
				weaponCargo _crate call BIS_fnc_consolidateArray
			]
		];
	};

    saveProfileNamespace;