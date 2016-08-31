params["_unit"];

	//Add event ( see initPlayerLocal.sqf for code comments )
	_unit addEventHandler [ "Killed", {
		_unit = _this select 0;
		_killer = _this select 1;

		if ( isPlayer _killer && !( _killer isEqualTo _unit ) ) then {

		_killedSide = side group _unit;
        _isEnemy = !(_killedSide isEqualTo side group _killer);

			if ( _isEnemy ) then {
	if !( _killer isEqualTo vehicle _killer ) then {
		switch ( _killer ) do {
			case ( driver vehicle _killer ) : {
				
				switch (side _killer) do {
								case west: {
								bluScore = bluScore + 1;
								publicVariable "bluScore";
								[ 250, 50, 1 ] remoteExec [ "fnc_updateStats", _killer ];
								};
								case east: {
								redScore = redScore + 1;
								publicVariable "redScore";
								[ 250, 50, 1 ] remoteExec [ "fnc_updateStats", _killer ];
								};
							};
				
				
			};
			case ( gunner vehicle _killer ) : {
				
				switch (side _killer) do {
								case west: {
								bluScore = bluScore + 1;
								publicVariable "bluScore";
								[ 250, 100, 1 ] remoteExec [ "fnc_updateStats", _killer ];
								};
								case east: {
								redScore = redScore + 1;
								publicVariable "redScore";
								[ 250, 100, 1 ] remoteExec [ "fnc_updateStats", _killer ];
								};
							};
			};
			case ( commander vehicle _killer ) : {
				
				switch (side _killer) do {
								case west: {
								bluScore = bluScore + 1;
								publicVariable "bluScore";
								[ 150, 100, 1 ] remoteExec [ "fnc_updateStats", _killer ];
								};
								case east: {
								redScore = redScore + 1;
								publicVariable "redScore";
								[ 150, 100, 1 ] remoteExec [ "fnc_updateStats", _killer ];
								};
							};
				
				
			};
			default {
				//crew
				
				switch (side _killer) do {
								case west: {
								bluScore = bluScore + 1;
								publicVariable "bluScore";
								[ 50, 50] remoteExec [ "fnc_updateStats", _killer ];
								};
								case east: {
								redScore = redScore + 1;
								publicVariable "redScore";
								[ 50, 50] remoteExec [ "fnc_updateStats", _killer ];
								};
							};
				
				
			};
		};
	}else{
		
		switch (side _killer) do {
								case west: {
								bluScore = bluScore + 1;
								publicVariable "bluScore";
								[ 250, 100, 1 ] remoteExec [ "fnc_updateStats", _killer ];
								};
								case east: {
								redScore = redScore + 1;
								publicVariable "redScore";
								[ 250, 100, 1 ] remoteExec [ "fnc_updateStats", _killer ];
								};
							};
		
		
	};
		}else{

					if !( _killer isEqualTo vehicle _killer ) then {
		switch ( _killer ) do {
			case ( driver vehicle _killer ) : {
				[ -250, -50] remoteExec [ "fnc_updateStats", _killer ];
			};
			case ( gunner vehicle _killer ) : {
				[ -250, -100] remoteExec [ "fnc_updateStats", _killer ];
			};
			case ( commander vehicle _killer ) : {
				[ -150, -100] remoteExec [ "fnc_updateStats", _killer ];
			};
			default {
				//crew
				[ -50, -50] remoteExec [ "fnc_updateStats", _killer ];
			};
		};
	}else{
		[ -250, -100, 1 ] remoteExec [ "fnc_updateStats", _killer ];
	};
				};
			
			};

		}];

	//Flag unit as having had event added
	_unit setVariable [ "hasEvent", true ];
