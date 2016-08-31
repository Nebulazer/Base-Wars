class NebulazerFunctions
{
	tag = "neb"; // Functions tag.  Functions will be called as [] call neb_fnc_addBounty
	class coreFunctions
	{
		// Since these are called from a file they'll be called by their names in the file, ie, neb_fnc_core_disableStamina
		class coreFunctions {file = "functions\coreFunctions.sqf"; description = "core functions, called on mission start."; preInit = 1;};
	};
	
	class functions
	{
		file = "functions"; // Folder where individual function files are stored.
		class addBounty {}; 
		class payBounty {};

	};
};