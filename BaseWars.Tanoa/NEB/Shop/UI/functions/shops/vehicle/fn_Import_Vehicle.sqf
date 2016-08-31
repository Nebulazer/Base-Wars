
params[ "_shopName" ];

{
	_className = configName _x;
	_index = -1;
	{
		if ( _className isKindOf _x ) exitWith { _index = _forEachIndex };
	}forEach [ "LAND", "AIR", "SEA" ];
		
	if ( _index > -1 ) then {
		_data = NEB_shopData select _index;
		_nul = _data pushBack [ _className, getNumber( _x >> "level" ), getNumber( _x >> "cost" ) ];
	};
	
}forEach ( "true" configClasses( missionConfigFile >> format[ "NEB_%1Data", _shopName ] ));