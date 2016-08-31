

[] call neb_fnc_core_instructions;
null = execVM "killTicker.sqf";

moduleName_keyDownEHId = findDisplay 46 displayAddEventHandler ["KeyDown", {hint str _this}];






