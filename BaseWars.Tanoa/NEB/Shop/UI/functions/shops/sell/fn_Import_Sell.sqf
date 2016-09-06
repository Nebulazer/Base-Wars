params[ "_shopName" ];

//Weapons, Attchments, Gear

_crateContents = [ "CARGO", "ALL" ] call NEB_fnc_shopCrate;
_crateContents params[ "_magazines", "_items", "_weapons", "_backpacks" ];


{
	_x params[ "_cargo", "_cfgData", "_condition", "_sellRatio" ];
	
	_shopData = NEB_shopData select _forEachIndex;
	_cfg = ( missionConfigFile >> _cfgData );
	{
		_x params [ "_item", "_count", [ "_ammo", -1 ] ];
		
		for "_i" from 1 to _count do {
			if ( isClass( _cfg >> _item ) && { _item call _condition } ) then 
				_nul = _shopData pushBack [ _item, getNumber( _cfg >> _item >> "cost" ) * _sellRatio, _ammo ];
			}else{
				//For testing so we know whats missiong a data class
				_nul = _shopData pushBack [ _item, 0, _ammo ];
			};
		};
	}forEach _cargo;
	
}forEach [
	//[ cargo, data to check, condition to add ]
	//Weapons
	[ _weapons, "NED_weaponData", { true }, 0.75 ],
	//Attachments
	[ _items, "NED_attachData", { true }, 0.75 ],
	//Gear
	[ _items, "NED_gearData", { true }, 0.75 ],
	//Magazines
	[ _magazines, "NED_attachData", { true }, 0.75 ] //chnage data structure when ammo is implemented
];
