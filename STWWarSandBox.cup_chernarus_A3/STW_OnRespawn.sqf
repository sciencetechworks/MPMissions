//STWFDisplaceRandomAngle={
//		if (isServer) exitWith {};
//		//if (!local player) exitWith{};
//		//waituntil { alive player };
//	
//		_rangle= random 180;
//		_rdist= 100+random 150;
//
//		_spawnPos= player getPos [_rdist,_rangle];
//		_isWater= surfaceIsWater _spawnPos;
//		if (!_isWater) then {player setPos _spawnPos;};
//		
//		//_playerName = name player;
//		//_msg = format ["%1 is down. Respawned at %2 m from the point he died. ",_playerName,_rdist];
//		//[-1, {player sideChat _this}, _msg] call CBA_fnc_globalExecute;	
//	true
//};
 
//[] call STWFDisplaceRandomAngle;
[] execvm "STW_InstallPlayerActions.sqf";
[] execvm "STW_DefineDefaultEquipment.sqf";
//sleep 2;


waitUntil {alive player;};
waitUntil {hasInterface}; 

_isPlayerOnWater = surfaceIsWater position player;
if (_isPlayerOnWater) then
{

_veh = "B_T_Boat_Transport_01_F" createVehicle position player;
 0 = ["AmmoboxInit",[_veh,true]] spawn BIS_fnc_arsenal;
//[_veh, true, true, true] call bis_fnc_initVehicle;
 player moveInDriver _veh;
 hint "Rearming: check your boat's inventory (you have got 5 minutes left).";
 _handle = [_veh] spawn {
					_veh=_this select 0; 
					sleep 300; 
					[ "AmmoboxExit", _veh ] call BIS_fnc_arsenal;
					removeAllActions _veh;
					hint "Rearming period is over";
					};
};

sleep 2;
//[player, true] call ace_fnc_setCrewProtection;
// player setVariable ["ACE_GForceCoef", 0.25];

removeAllWeapons player;
removeAllItems player;
removeAllAssignedItems player;
removeUniform player;
removeVest player;
removeBackpack player;
removeHeadgear player;
removeGoggles player;

_stwPersistenceDatabase = ["new", "profile"] call OO_PDW;
_bool = ["loadInventory", ["PersistedInventory", player]] call _stwPersistenceDatabase;
sleep 4;

// If player is nude, load default equipment depending on day time.
//hint ("daytime"+(str daytime));
_uniform = uniform player;
if (isNil("_uniform")||(_uniform=="")) then
{

 if (
		((daytime>=0)&&(daytime<=6))||
		((daytime>=21) && (daytime <=24))
	) then { 
	[] call STWFInstallDefaultNightEquipment;
 } else
 {
	[] call STWFInstallDefaultDayEquipment;
 };
};
//DO NOT RECOVER POSITION FROM SERVER WHEN IN RESPAWN POSITIONS MODE.
//sleep 10;
//STWPERSISTSTATUSLOAD=[(name player)];
//publicVariableServer "STWPERSISTSTATUSLOAD";

