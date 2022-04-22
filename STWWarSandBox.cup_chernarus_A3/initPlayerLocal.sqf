//setViewDistance 1100;
//setObjectViewDistance [1100,100];
[] execvm "STW_InstallPlayerActions.sqf";
//ENABLE NEXT LINE FOR HEARING MODULE
//[] execvm "land\STW_AIHearing.sqf";
//[] execvm "STW_InstallDefaultEquipment.sqf";
[] execVM  "STW_InstallRespawnHandlersOnPlayer.sqf";



waitUntil {!isNull player};
waitUntil {alive player;};
waitUntil {hasInterface}; 
waitUntil {time > 1}; 

//[player, true] call ace_fnc_setCrewProtection;
//player setVariable ["ACE_GForceCoef", 0.25];
//
//
//removeAllWeapons player;
//removeAllItems player;
//removeAllAssignedItems player;
//removeUniform player;
//removeVest player;
//removeBackpack player;
//removeHeadgear player;
//removeGoggles player;
////STWPERSISTINVENTORYLOAD=[(name player)];
////publicVariableServer "STWPERSISTINVENTORYLOAD";
//_stwPersistenceDatabase = ["new", "profile"] call OO_PDW;
//_bool = ["loadInventory", ["PersistedInventory", player]] call _stwPersistenceDatabase;
//
//sleep 1;
//diag_log "Requesting original position and status";
//STWPERSISTSTATUSLOAD=[(name player)];
//publicVariableServer "STWPERSISTSTATUSLOAD";

///// PERSIST PLAYER POSITION EVERY 30 seconds
/*
[] spawn  {
 waitUntil {alive player;};
 sleep 60;
 while {true} do
 {
	if (alive player) then 
	{
		STWPERSISTSTATUSSAVE=[(name player)];
		publicVariableServer "STWPERSISTSTATUSSAVE";
		diag_log "A request to persist the position was sent to the server.";
		//Store inventory on client DB
		_stwPersistenceDatabase = ["new", "profile"] call OO_PDW;
		_bool = ["saveInventory", ["PersistedInventory", player]] call _stwPersistenceDatabase;
		
		diag_log "Player Inventory Persisted";
	};
	sleep 30;
 };
};
*/
_script_handler=[] execvm "STW_OnRespawn.sqf";
waitUntil { scriptDone _script_handler };

//INVENTORY PERSISTENCE IS HANDLED BY CLIENT SIDE DB
//STWPERSIST_INVENTORY_LOAD_REQUEST=[(name player)];
//publicVariableServer "STWPERSIST_INVENTORY_LOAD_REQUEST";

//"STWPERSIST_INVENTORY_LOAD_RESPONSE" addPublicVariableEventHandler {
//  _broadcastVarName = _this select 0;
//  _broadcastVarValue = _this select 1;
//  _destination_playerName=_broadcastVarValue select 0;
//  _inventory=_broadcastVarValue select 1;
//  diag_log format ["%1 %2 inventory received response",_destination_playerName,_inventory];
//  _player_name=name player;
//  
//  if (_player_name==_destination_playerName) then
//  {
//	removeAllWeapons player;
//	removeAllItems player;
//	removeAllAssignedItems player;
//	removeUniform player;
//	removeVest player;
//	removeBackpack player;
//	removeHeadgear player;
//	removeGoggles player;
//	
//	_headgear = _inventory select 0;
//	_goggles = _inventory select 1;
//	_uniform = _inventory select 2;
//	_uniformitems = _inventory select 3;
//	_vest = _inventory select 4;
//	_vestitems = _inventory select 5;
//	_backpack = _inventory select 6;
//	_backpackitems = _inventory select 7;
//	_fullmagazine = _inventory select 8;
//	_primaryweapon = _inventory select 9;
//	_primaryweaponitems = _inventory select 10;
//	_secondaryweapon = _inventory select 11;
//	_secondaryweaponitems = _inventory select 12;
//	_handgunweapon = _inventory select 13;
//	_handgunweaponitems = _inventory select 14;
//	_assigneditems = _inventory select 15;
//	
//	player addHeadgear _headgear;
//	player forceAddUniform _uniform;
//	player addGoggles _goggles;
//	player addVest _vest;
//		{
//			if(!(_x isEqualTo "") and (_x isKindOf ["ItemCore", configFile >> "CfgWeapons"] )) then {
//				_object addItemToUniform _x;
//			};
//		}foreach _uniformitems;
//	
//		{
//			if(!(_x isEqualTo "") and (_x isKindOf ["ItemCore", configFile >> "CfgWeapons"] )) then {
//				_object addItemToVest _x;
//			};
//		}foreach _vestitems;
//	
//		if!(_backpack isEqualTo "") then {
//			_object addbackpack _backpack;
//			{
//				if(!(_x isEqualTo "") and (_x isKindOf ["ItemCore", configFile >> "CfgWeapons"] )) then {
//					_object addItemToBackpack _x;
//				};
//			} foreach _backpackitems;
//		};
//	
//		{
//			if!(_x isEqualTo "") then {
//				_object addMagazine [_x select 0, _x select 1];
//			};
//		} foreach _fullmagazine;
//	
//		//must be after assign items to secure loading mags
//		_object addweapon _primaryweapon;
//	
//		{
//			if(_x != "") then {
//				_object addPrimaryWeaponItem _x;
//			};
//		} foreach _primaryweaponitems;
//	
//		_object addweapon _secondaryweapon;
//	
//		{
//			if(_x != "") then {
//				_object addSecondaryWeaponItem _x;
//			};
//		} foreach _secondaryweaponitems;
//	
//	
//		_object addweapon _handgunweapon;
//	
//		{
//			if(_x != "") then {
//				_object addHandgunItem _x;
//			};
//		} foreach _handgunweaponitems;
//	
//		{
//			if(_x != "") then {
//				_object addweapon _x;
//			};
//		} foreach _assigneditems;
//	
//		if (needReload _object == 1) then {reload _object};
//		true;
// };
//};

