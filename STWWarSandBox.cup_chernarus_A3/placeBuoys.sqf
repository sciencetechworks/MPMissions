// at this point in the script, everyone except the server will exit
if (!isServer) exitWith {};
//if (!((name player)=="Cpt Horny")) exitWith {};
//if (BUOYS_PLACED==true) exitWith {};
//waitUntil {sleep 0.5; alive player};
diag_log format ["***** WELCOME HORNY: BUOYS ******"];
	_worldCenter = getArray (configfile >> "CfgWorlds" >> worldName >> "centerPosition");
	_worldSize = getnumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
	_worldWidthX= 2*(_worldCenter select 0);
	_worldHeightY= 2*(_worldCenter select 1);
	
	diag_log format ["World Center %1", _worldCenter];
	diag_log format ["World Size %1", _worldSize];
	diag_log format ["World Width %1", _worldWidthX];
	diag_log format ["World Height %1", _worldHeightY];

	_xStep=250;
	_yStep=250;
	_counter=0;
	
	_dNE=0;
	_dN=1;
	_dNE=2;
	_dO=3;
	_dC=4;
	_dE=5;
	_dSO=6;
	_dS=7;
	_dSE=8;
	
	// Displacement from center vectors, used to get N,S,W,E from center position
	_vNW=[[-1,-1]];
	_vN=[[-1,0]];
	_vNE=[[-1,1]];
	_vW=[[0,-1]];
	_vC=[[0,0]];
	_vE=[[0,1]];
	_vSW=[[1,-1]];
	_vS=[[1,0]];
	_vSE=[[1,1]];
	
	
	//_sampleM=[["NO","N","NE"],["O","C","E"],["SO","S","SE"]];
	//diag_log format ["SAMPLE %1", _sampleM ];
	
	// FUNCTION: Returns the Dimension os a Matrix
	_stwMatrixDim=
	{
		_result=[0,0];
		_result set [0,count _this];
		_result set [1,count (_this select 0)];
		_result;
	};
	
//	_sampleM=[
//	[1,0,0],
//	[0,1,0]
//	];
//	
//	diag_log format ["Dimension %1 = %2",_sampleM ,_sampleM call _stwMatrixDim ];
	
//	_sampleM1=[
//	[1,0,0],
//	[0,1,0],
//	[0,0,1]
//	];
//	
//	_sampleM2=[
//	[0,2,0],
//	[4,0,0],
//	[0,0,3]
//	];
	
	// FUNCTION: Gets Matrix[i,j]
	_stwGetMatrixElem=
	{
	 _m = _this select 0;
	 _i = (_this select 1) select 0;
	 _j = (_this select 1) select 1;
	 //diag_log format ["_stwGetMatrixElem %1 %2 %3", _m,_i,_j ];
	 
	 _row =_m select _i;
	 //diag_log format ["row %1", _row ];
	 _value=_row select _j;
	 //diag_log format ["value %1", _value ];
	 _value;
	};
	
	// Sets Matrix[i,j]=v
	_stwSetMatrixElem = 
	{
	 _m = _this select 0;
	 _i = (_this select 1) select 0;
	 _j = (_this select 1) select 1;
	 _v = _this select 2;
	 //diag_log format ["%1 %2 %3 %4", _m,_i,_j,_v ];
	 _row =_m select _i;
	 
	 _row set [_j,_v];
	 //diag_log format ["m = %1", _m];
	 _m;
	};
	
//	_sampleM3=_sampleM1;
//	
//	diag_log format ["before = %1", _sampleM3];
//	_sampleM3=[_sampleM1,1,1,33] call _stwSetMatrixElem;
//	diag_log format ["after = %1", _sampleM3];

	// FUNCTION: Matrix addition : Matrix = MA + MB
	_stwMatrixSum=
	{
	 
	 _MA = _this select 0;
	 _MB = _this select 1;
	 _dim= _MA call _stwMatrixDim;
	 _rows= _dim select 0;
	 _cols= _dim select 1;
	 _result= +_MA; //unary + makes a COPY of the matrix
	 
	 for [ {private "_i"; _i=0;},{_i<_rows},{_i=_i+1}] do
	{
		
		for [ {private "_j"; _j=0;},{_j<_cols},{_j=_j+1}] do
		{
			_a = [_MA,[_i,_j]] call _stwGetMatrixElem;
			_b = [_MB,[_i,_j]] call _stwGetMatrixElem;
			_c = _a + _b;
			_result = [_result,[_i,_j],_c] call _stwSetMatrixElem;
			//diag_log format ["%1,[%2 %3] = %4", _MA,_i,_j,[_MA,_i,_j] call _stwGetMatrixElem ];
		};
	};
	 
	 _result;
	};	
	
//	_sampleM3=[_sampleM1,_sampleM2] call _stwMatrixSum;
//	diag_log format ["%1+%2=%3", _sampleM1,_sampleM2,_sampleM3 ];
	
	
	// FUNCTION: Gets NW value of M4x4 Matrix
	_stwGetNW=
	{
		_M44 = _this;
		_vMC= [[1,1]];
		_pos = [_vMC,_vNW] call _stwMatrixSum;
		[_M44, _pos select 0] call _stwGetMatrixElem;
	};
	
	// FUNCTION: Gets N value of M4x4 Matrix
	_stwGetN=
	{
		_M44 = _this;
		_vMC= [[1,1]];
		_pos = [_vMC,_vN] call _stwMatrixSum;
		[_M44, _pos select 0] call _stwGetMatrixElem;
	};
	
	// FUNCTION: Gets NE value of M4x4 Matrix
	_stwGetNE=
	{
		_M44 = _this;
		_vMC= [[1,1]];
		_pos = [_vMC,_vNE] call _stwMatrixSum;
		[_M44, _pos select 0] call _stwGetMatrixElem;
	};
	
	// FUNCTION: Gets W value of M4x4 Matrix
	_stwGetW=
	{
		_M44 = _this;
		_vMC= [[1,1]];
		_pos = [_vMC,_vW] call _stwMatrixSum;
		[_M44, _pos select 0] call _stwGetMatrixElem;
	};
	
	// FUNCTION: Gets Center value of M4x4 Matrix
	_stwGetC=
	{
		_M44 = _this;
		_vMC= [[1,1]];
		_pos = [_vMC,_vC] call _stwMatrixSum;
		[_M44, _pos select 0] call _stwGetMatrixElem;
	};
	
	// FUNCTION: Gets E value of M4x4 Matrix
	_stwGetE=
	{
		_M44 = _this;
		_vMC= [[1,1]];
		_pos = [_vMC,_vE] call _stwMatrixSum;
		[_M44, _pos select 0] call _stwGetMatrixElem;
	};
	
	// FUNCTION: Gets SW value of M4x4 Matrix
	_stwGetSW=
	{
		_M44 = _this;
		_vMC= [[1,1]];
		_pos = [_vMC,_vSW] call _stwMatrixSum;
		[_M44, _pos select 0] call _stwGetMatrixElem;
	};
	
	// FUNCTION: Gets S value of M4x4 Matrix
	_stwGetS=
	{
		_M44 = _this;
		_vMC= [[1,1]];
		_pos = [_vMC,_vS] call _stwMatrixSum;
		[_M44, _pos select 0] call _stwGetMatrixElem;
	};
	
	// FUNCTION: Gets SE value of M4x4 Matrix
	_stwGetSE=
	{
		_M44 = _this;
		_vMC= [[1,1]];
		_pos = [_vMC,_vSE] call _stwMatrixSum;
		[_M44, _pos select 0] call _stwGetMatrixElem;
	};
	
	//_sampleResult= _sampleM call _stwGetSE;
	//diag_log format ["--> %1", _sampleResult ];
	
//	
//	_stwIsCoast = {
//		private ["_result"];
//		if (surfaceIsWater)
//		
//	};
//	
	_counter=0;
	for [ {private "_y"; _y=0;},{_y<=_worldHeightY+4*_yStep},{_y=_y+_yStep}] do
	{
		
		for [ {private "_x"; _x=0;},{_x<=_worldWidthX+4*_xStep},{_x=_x+_xStep}] do
		{
			_position2D= [_x,_y];
			_overShore = !(_position2D isFlatEmpty  [-1, -1, -1, -1, 0, true] isEqualTo []);
			
			
			if (_overShore) then
			{
				_nearBuildings= nearestObjects [_position2D, ["House", "Building"], 100];
				_howManyBuildings = count _nearBuildings;
				if (_howManyBuildings>3) then 
				{
					//_markername = format ["BuoyMarker_%1", _counter];
					//_mkr = createMarker[ _markername, _position2D ];
					//_mkr setMarkerShape "ELLIPSE";
					//_mkr setMarkerSize [ 400, 400 ];
					//_mkr setMarkerColor "colorBlue";
					
					_center = [_position2D select 0,_position2D select 1,0];
					_radius=500;
					for [ {private "_a"; _a=0;},{_a<360},{_a=_a+20}] do
					{
					  _buoyPosition=_center vectorAdd [_radius * sin _a, _radius * cos _a, 0];
					  //_distToBuilding = _buoyPosition distance2D (getPos (_nearBuildings select 0));
					  _distToShore = _buoyPosition distance2D _position2D;
					  //diag_log format ["Checking Buoy %1", _counter];
					  if ((surfaceIsWater _buoyPosition)&&(_distToShore>300)) then 
					  {
					   _buoy= "Land_BuoyBig_F" createvehicle [_buoyPosition select 0,_buoyPosition select 1];
					   _buoy enableDynamicSimulation true;
					   _buoy enableSimulationGlobal true;
					   _buoy allowDamage true;
					   //_markername = format ["Buoy_%1", _counter];
					   //_mkr2 = createMarker[ _markername, _buoyPosition ];
					   //_mkr2 setMarkerShape "ELLIPSE";
					   //_mkr2 setMarkerSize [ 10, 10 ];
					   //_mkr2 setMarkerColor "colorBlack";
					   _counter=_counter+1;
					  };
					  
					};		
				};
			};
					
			//diag_log format ["Checking Buoys at %1 %2 %3 %4", _x,_y,_overShore,_nearBuildings];
			//_markername = format ["Pos_%1", _counter];
			//_mkr2 = createMarker[ _markername, _position2D ];
			//_mkr2 setMarkerShape "ELLIPSE";
			//_mkr2 setMarkerSize [ 10, 10 ];
			//_mkr2 setMarkerColor "colorBlack";
			//_counter=_counter+1;		
			sleep 1;
		};
	};
	
	
	diag_log format ["Placing buoys finished."];
	STW_BUOYS_PLACED=true;
	publicVariable "STW_BUOYS_PLACED";