if (isServer) then 
	{
	call compile preprocessFile "HAS\userConfig.sqf";
	call compile preprocessFile "HAS\HAS_fnc.sqf";
	[] call RYD_HAS_Init;
	};
	
_nul = []execVM "AF_Keypad\AF_KP_vars.sqf";
//nul = [] execVM "placeBuoys.sqf";
//nul = [] execVM "placeRoadStreetLamps.sqf";
//nul = [] execVM "STWAnimals.sqf";
//[]execVM "eos\OpenMe.sqf";
//nul = [] execVM "land\STW_Cities.sqf";
//nul = [] execVM "land\STW_Airports.sqf";
//nul = [] execVM "land\STW_StrategicPoints.sqf";
execVM "JWC_CASFS\initCAS.sqf";


STW_HOW_MANY_BOAT_PATROLS=0;
STW_HOW_MANY_HELO_PATROLS=0;


call compilefinal preprocessFileLineNumbers "persistence\oo_pdw.sqf";
//call compilefinal preprocessFileLineNumbers ("water\STW_WaterUtils.sqf");

//MOVING TARGET MANAGER
//"STWTARGETHIT" addPublicVariableEventHandler {
//		diag_log format ["PUBLIC VARIABLE HIT %1",_this];
//	};

	
//REMOTE PERSISTENCE SYSTEM


if (isServer) then
{
	
	diag_log "========== INITIALISING SERVER (START) ===========";
	/*	
	

	//INIT THE WATER DETECTION SYSTEM
	//compile preprocessFile ("water\STW_WaterUtils.sqf");
	[[[[0,0],[worldSize,worldSize]]],0] execVM "water\STW_DetectWaterAreasInit.sqf";

	[] spawn {
	 sleep 10;
	 for [{_i=0}, {_i<STW_HOW_MANY_BOAT_PATROLS}, {_i=_i+1}] do
	 { 
		[] execVM "water\STWSpawnEnemyShip.sqf";
	 };
	 
	 for [{_i=0}, {_i<STW_HOW_MANY_HELO_PATROLS}, {_i=_i+1}] do
	 { 
		 [] execVM "air\STWSpawnEnemyHelo.sqf";
     };
	 
	 
	};
	*/
//	//INIT THE LAND DETECTION SYSTEM
//	//compile preprocessFile ("land\STW_LandUtils.sqf");
//	[[[[0,0],[worldSize,worldSize]]],0] execVM "land\STW_DetectLandAreasInit.sqf";


	
	
	// AUTOMATIC BOMBING RUNS OVER CITIES
//	[]spawn {
//		 _waitBetweenBombingRaids=[5400];
//		 sleep (selectRandom _waitBetweenBombingRaids);
//		 _waitBetweenBombingRuns=[17,23,35,45,125];
//		 
//		 _raidDuration=[300,600,900];
//		 _bombingGroupSize=[1,2,3,4,5];
//		 _town=selectRandom STW_TOWNS;
//		 _traid=0;
//		 _tbombRaid=selectRandom _raidDuration;
//		 [west, "HQ"] sideChat format ["Air Raid Bombing over %1 expected duration %2 minutes",_town select 1,_tbombRaid/60];
//		 while{true} do {
//		  for [ {private "_x"; _i=0;},{(_i<(selectRandom _bombingGroupSize))},{_i=_i+1}] do
//		  {
//			_town execVM "JWC_CASFS\stwCAS.sqf";
//		  };
//		  _tbombRun=selectRandom _waitBetweenBombingRuns;
//		  sleep _tbombRun;
//		  _traid=_traid+_tbombRun; 
//		  if (_traid>_tbombRaid) then
//		  {
//			_traid=0;
//			_tbombRaid=selectRandom _raidDuration;
//			_town=selectRandom STW_TOWNS;
//			sleep (selectRandom _waitBetweenBombingRaids);
//			[west, "HQ"] sideChat format ["Air Raid Bombing over %1 expected duration %2 minutes",_town select 1,_tbombRaid/60];
//		  };
//		 };
//	};

	//sleep 30;
	//for [{_i=0}, {_i<4}, {_i=_i+1}] do
	//{ 
	//	nul = [] execVM "land\STWLandMines.sqf";
	//};
	
	
	diag_log "========== INITIALISING SERVER (END) ===========";	
};

//[] execVM "a3_custom\init\fn_init.sqf";