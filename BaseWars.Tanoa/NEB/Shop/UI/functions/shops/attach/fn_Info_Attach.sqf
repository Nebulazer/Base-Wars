#include "..\..\shopMacros.hpp"

params[ "_className" ];

_cfg = ( configFile >> "CfgWeapons" >> _className );

// "description"
// "displayName"
// "overviewPicture"
// "picture"
// "itemInfo" >> "mass"
// "ItemInfo" >> "OpticsModes" configClasses 
//		"ItemInfo" >> "OpticsModes" >> # >> "discreteDistance"
// 		"ItemInfo" >> "OpticsModes" >> # >> "distanceZoomMin"
// 		"ItemInfo" >> "OpticsModes" >> # >> "distanceZoomMax"
//		"ItemInfo" >> "OpticsModes" >> # >> "visionMode"


UICTRL( STXT_INFO_IDC ) ctrlSetStructuredText parseText format [
	"<t align='center'>%1</t><br/>
	<t align='left'>%3</t><br/>
	<t align='left'>%3</t><br/>
	<t align='left'>%3</t><br/>
	<t align='left'>%2</t><br/>
	<t align='left'>%3</t>",
	getText( _cfg >> "descriptionShort" ),
				    	
	getText( configFile >> "CfgWeapons" >> [ _className ] call BIS_fnc_baseWeapon >> "Library" >> "libTextDesc" ),
	"-------------------------------------------------------------------------------------"
];