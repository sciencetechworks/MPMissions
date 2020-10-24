if (isNil "STW_MARKER_COUNTER") then
{
 STW_MARKER_COUNTER=0;
};

stwfIncrementMarkerCounter={
 STW_MARKER_COUNTER=STW_MARKER_COUNTER+1;
};


_stwfSelectRandowTownPosition=
{
 _town=_this;
 diag_log format["Selected town for bombing:%1",_town];
 _townPos=[_town select 2 select 0,_town select 2 select 1];
 _nRoads= _townPos nearRoads 300;
 _rPos=_townPos;
 if (count _nRoads>0) then
 {
	 _rRoad=selectRandom _nRoads;
	 _rPos=getPos _rRoad;
 };
 
 _rPos
};




_stwfCASCity={
	_city=_this;
	_CASTYPE=["JDAM","CBU","NAPALM"];
	_markerName=format ["STW_CAS_TARGET_%1",STW_MARKER_COUNTER];
	[] call stwfIncrementMarkerCounter;
	_pos=_city call _stwfSelectRandowTownPosition;
	diag_log format ["Ordering Bombing onto:%1",_pos];
	_marker = createMarker[_markerName, _pos];
	_marker setMarkerType 'mil_destroy';
	_marker setMarkerSize[0.5, 0.5];
	_markerName setMarkerAlphaLocal 0;
	//_marker setMarkerColor 'ColorRed';
	//_marker setMarkerText ' CAS';
	

	_lockToOwner=true;
	_num=12;
	_actionid=1;
	_owner=STWCASCOMMANDER;
	_casLaunched=selectRandom _CASTYPE;
	
	[_owner, worldSize, _lockToOwner, _num, _casLaunched,_markerName,_actionid] execVM "JWC_CASFS\CAS.sqf";
	
	_markerName spawn {
			sleep 240;
			deleteMarker _this;
		}
};

_this call _stwfCASCity;