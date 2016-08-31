params[ "_shopName" ];


{
	_className = configName _x;
	_button = -1;
	_button = switch( true ) do {
		case ( isClass( configFile >> "CfgWeapons" >> configName _x ) ) : {
			switch( getNumber( configFile >> "CfgWeapons" >> configName _x >> "itemInfo" >> "type" ) ) do {
				//uniform
				case ( 801 ) : {
					0
				};
				//vest
				case ( 701 ) : {
					1
				};
				//nvg
				case ( 616 ) : {
					5
				};
				//helmets
				case ( 605 ) : {
					3
				};
			};
		};
		case ( isClass( configFile >> "CfgGlasses" >> configName _x ) ) : {
			4
		};
		case ( isClass( configFile >> "CfgVehicles" >> configName _x ) ) : {
			2
		};
	};
	
	if ( _button > -1 ) then {
		_data = NEB_shopData select _button;
		_nul = _data pushBack [ _className, getNumber( _x >> "level" ), getNumber( _x >> "cost" ) ];
	};
		
}forEach ( "true" configClasses ( missionConfigFile >> format[ "NEB_%1Data", _shopName ] )); //class in shopData to pull info from