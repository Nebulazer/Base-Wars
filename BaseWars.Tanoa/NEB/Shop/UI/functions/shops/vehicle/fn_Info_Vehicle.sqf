#include "..\..\shopMacros.hpp"

params[ "_className" ];

_cfg = ( configFile >> "CfgVehicles" >> _className );

_weapons = "";
{
	if !( getText( configFile >> "CfgWeapons" >> _x >> "displayName" ) isEqualTo "" ) then {
		_weapons = format[ "%1%2, ", _weapons, getText( configFile >> "CfgWeapons" >> _x >> "displayName" ) ];
	};
}forEach ( getArray( _cfg >> "weapons"));
{
	{
		if !( getText( configFile >> "CfgWeapons" >> _x >> "displayName" ) isEqualTo "" ) then {
			_weapons = format[ "%1%2, ", _weapons, getText( configFile >> "CfgWeapons" >> _x >> "displayName" ) ];
		};
	}forEach getArray( _x >> "weapons" );
}forEach ( "isArray( _x >> 'weapons' )" configClasses ( _cfg >> "Turrets" ));

if ( _weapons isEqualTo "" ) then { _weapons = "NONE" };

UICTRL( STXT_INFO_IDC ) ctrlSetStructuredText parseText format [
	"<t align='left'>Weapons:</t><br/>
	<t align='left'>%1</t><br/>
	<t align='left'>%6</t><br/>
	<t align='left'>Passengers:</t> <t align='right'>%2</t>
	<t align='left'>%6</t><br/>
	<t align='left'>Max Speed:</t> <t align='right'>%3</t>
	<t align='left'>%6</t><br/>
	<t align='left'>Inventory:</t> <t align='right'>%4</t>
	<t align='left'>%6</t><br/>
	<t align='left'>Armor:</t> <t align='right'>%5</t>
	<t align='left'>%6</t><br/>",
	_weapons,
	[_className,true] call BIS_fnc_crewCount,
	getNumber( _cfg >> "maxSpeed"),
	getNumber( _cfg >> "maximumLoad"),
	getNumber( _cfg >> "armor"),
	"-------------------------------------------------------------------------------------"
];
