
//NVG,  Headgear, Vest, Uniform
gear = "";
_RETURN = [ 13, 10 ];
_TAB = [ 09 ];
{
{
	gear = formatText[ "%1class %2
{
%3cost = 0;
%3level = 0;
};%4", gear, configName _x, toString _tab, toString _return ];
}forEach ( format[ "getnumber( _x >> 'scope' ) isEqualTo 2 && { getNumber( _x >> 'itemInfo' >> 'type' ) isEqualTo %1 } ", _x ]configClasses ( configFile >> "CfgWeapons" ));
}forEach [ 616, 605, 701, 801 ];

copyToClipboard str gear;


//Glasses
gear = "";
_RETURN = [ 13, 10 ];
_TAB = [ 09 ];
{
	gear = formatText[ "%1class %2
{
%3cost = 0;
%3level = 0;
};%4", gear, configName _x, toString _tab, toString _return ];
}forEach ( "getnumber( _x >> 'scope' ) isEqualTo 2 "configClasses ( configFile >> "CfgGlasses" ));

copyToClipboard str gear;


//Backpacks
gear = "";
_RETURN = [ 13, 10 ];
_TAB = [ 09 ];
{
	gear = formatText[ "%1class %2
{
%3cost = 0;
%3level = 0;
};%4", gear, configName _x, toString _tab, toString _return ];
}forEach ( "getnumber( _x >> 'scope' ) isEqualTo 2 && { getnumber( _x >> 'isbackpack' ) isEqualTo 1 } "configClasses ( configFile >> "CfgVehicles" ));

copyToClipboard str gear;


