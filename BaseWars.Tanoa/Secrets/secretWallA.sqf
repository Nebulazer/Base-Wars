_myLvl = player getVariable [ "level", 0 ];

if (_myLvl < 3) then {	
	hint " LVL TOO LOW TO UNLOCK THIS SECRET ";
		}else{
deleteVehicle secretWallA;
removeAllactions player;
};