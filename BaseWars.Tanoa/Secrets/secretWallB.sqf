_myLvl = player getVariable [ "level", 0 ];

if (_myLvl < 5) then {	
	hint " LVL TOO LOW TO UNLOCK THIS SECRET ";
		}else{
deleteVehicle secretWallB;
removeAllactions player;
};