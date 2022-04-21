

if (isDedicated) exitwith {};
waituntil {alive player};

_nul = []execVM "AF_Keypad\AF_KP_vars.sqf";

if (isNil "STW_ALLOW_ARSENAL") then {
    STW_ALLOW_ARSENAL=true;
    publicVariable "STW_ALLOW_ARSENAL";
};

if (isNil "STW_ALLOW_TELEPORT") then {
    STW_ALLOW_TELEPORT=true;
    publicVariable "STW_ALLOW_TELEPORT";
};

STW_REQUEST_CAS_ALLOWED_PLAYERS=["CPT HORNY"];

///////////// FUNCTION
// Provide a flashlight to every enemy unit
STWFAddFlashLightToEnemyUnits={
    //hint "Providing enemies with flashlights";

    //ForEach
    {
        _unit = _x;

        // Only run where the unit is not on the player side, it isn't a player and doesn't have a flashlight
        if ((side _unit!=playerSide)) then { //&& (!isplayer _unit) && !("acc_flashlight" in primaryWeaponItems _unit)) then {

            // Remove laser if equipped
            if ("acc_pointer_IR" in primaryWeaponItems _unit) then {_x removePrimaryWeaponItem "acc_pointer_IR"};
            _unit addPrimaryWeaponItem "acc_flashlight";    // Add flashlight

            // Removes NVGs from unit
            {
                if (_x in assigneditems _unit) exitWith {_unit unlinkItem _x};
            }
            forEach ["NVGoggles_OPFOR","NVGoggles_INDEP","NVGoggles"];
            //_unitName = name _unit;
            //_msg= format ["%1 receives a Flashlight",_unitName];
            //[-1, {player globalChat _this}, _msg] call CBA_fnc_globalExecute;
        };
        // Forces flashlights on
        //_unit enablegunlights "forceOn";
        _unit enablegunlights "AUTO";
    } forEach allUnits;
};
/////////////////////////////

///////////// FUNCTION
// Provide Night Vision to every enemy unit
STWFAddNightVisionToEnemyUnits={
    //hint "Providing enemies with Night Vision";

    //ForEach
    {
        _unit = _x;

        // Only run where the unit is not on the player side, it isn't a player and doesn't have a flashlight
        if ((side _unit!=playerSide) && (!isplayer _unit) ) then {
            // Remove laser if equipped
            _x addPrimaryWeaponItem "acc_pointer_IR";
            _unit removePrimaryWeaponItem "acc_flashlight";

            _unit additem "NVGoggles";
            _unit assignitem "NVGoggles";
            _unit action["NVGoggles", _unit];

            //_unitName = name _unit;
            //_msg= format ["%1 receives NVGoogles",_unitName];
            //[-1, {player globalChat _this}, _msg] call CBA_fnc_globalExecute;
        };
    } forEach allUnits;
};
/////////////////////////////

///////////// FUNCTION
// Provide a flashlight to every PLAYER unit
STWFAddFlashLightToFriendUnits={

    hint "Providing friends with flashlights";
    //ForEach
    {
        _unit = _x;

        // Only run where the unit is not on the player side, it isn't a player and doesn't have a flashlight
        if ((side _unit==playerSide) && !("acc_flashlight" in primaryWeaponItems _unit)) then {
            // Remove laser if equipped
            if ("acc_pointer_IR" in primaryWeaponItems _unit) then {_x removePrimaryWeaponItem "acc_pointer_IR"};
            _unit addPrimaryWeaponItem "acc_flashlight";    // Add flashlight
            _nvgs = hmd _unit;
            _unit removeWeapon _nvgs;
            _unit unassignItem _nvgs;
            _unit removeItem _nvgs;
            removeHeadGear _unit;
            // Removes NVGs from unit
            //{
            //	if (_x in assigneditems _unit) exitWith {_unit unlinkItem _x};
            //} forEach ["NVGoggles_OPFOR","NVGoggles_INDEP","NVGoggles"];
        };
        // Forces flashlights on
        //_unit enablegunlights "forceOn";
        _unit enablegunlights "forceOn";
    }
    forEach allUnits;
};
/////////////////////////////
///////////// FUNCTION
// Provide Night Vision to every friend unit
STWFAddNightVisionToFriendUnits={

    //ForEach
    {
        _unit = _x;
        // Only run where the unit is not on the player side, it isn't a player and doesn't have a flashlight
        if ((side _unit==playerSide)  ) then {
            // Remove laser if equipped
            _x addPrimaryWeaponItem "acc_pointer_IR";
            _unit removePrimaryWeaponItem "acc_flashlight";

            _unit additem "NVGoggles";
            _unit assignitem "NVGoggles";
            _unit action["NVGoggles", _unit];
        };
    } forEach allUnits;
};
/////////////////////////////

STWG_Teleport_Access_Code="1";
STWG_Arsenal_Access_Code= "1";
STWG_Load_Inventory_Access_Code= "1";
STWG_Load_Position_Access_Code= "1";
STWG_Request_CAS_Access_Code= "1";
STWG_Skip_Mission_Success_Access_Code="1";

stwf_checkKeyPadValue={
    params ["_message","_expectedValidValues"];
    OutputText="";
    ClearText=_message;
    createDialog "AF_Keypad";
    waitUntil {sleep 1;
               ((count (toArray OutputText))!=0)};
    _value=OutputText;
    OutputText="";
    _result=false;
    if (_value in _expectedValidValues) then
    {
        _result=true;
    };
    _result;
};

stwf_teleportToBaseAction= {
    _checkCode=["Clearance code",[STWG_Teleport_Access_Code]] call stwf_checkKeyPadValue;
    if (!_checkCode) exitwith{false};

    if (STW_ALLOW_TELEPORT) then
    {
        _playerName = name player;
        _msg= format ["%1 is being teleported to base.",_playerName];
        [-1, {player globalChat _this}, _msg] call CBA_fnc_globalExecute;
        _stwBaseHqPos= getMarkerPos "marker_STWBASEHQ";
        player setPos(_stwBaseHqPos);
    } else {
        _playerName = name player;
        _msg= format ["%1 is requesting teleport.",_playerName];
        [-1, {player globalChat _this}, _msg] call CBA_fnc_globalExecute;
    };
};

stwf_requestArsenalAction= {
    _checkCode=["Clearance code",[STWG_Arsenal_Access_Code]] call stwf_checkKeyPadValue;
    if (!_checkCode) exitwith{false};
    if (STW_ALLOW_ARSENAL) then
    {
        _playerName = name player;
        _msg= format ["%1 is opening the arsenal.",_playerName];
        [-1, {player globalChat _this}, _msg] call CBA_fnc_globalExecute;
        ["Open",true] spawn BIS_fnc_arsenal;
    } else {
        _playerName = name player;
        _msg= format ["%1 is requesting the arsenal.",_playerName];
        [-1, {player globalChat _this}, _msg] call CBA_fnc_globalExecute;
    };
};

stwf_loadInventoryAction={
    _checkCode=["Clearance code",[STWG_Load_Inventory_Access_Code]] call stwf_checkKeyPadValue;
    if (!_checkCode) exitwith{false};
    removeAllWeapons player;
    removeAllItems player;
    removeAllAssignedItems player;
    removeUniform player;
    removeVest player;
    removeBackpack player;
    removeHeadgear player;
    removeGoggles player;
    //STWPERSISTINVENTORYLOAD=[(name player)];
    //publicVariableServer "STWPERSISTINVENTORYLOAD";
    _stwPersistenceDatabase = ["new", "profile"] call OO_PDW;
    _bool = ["loadInventory", ["PersistedInventory", player]] call _stwPersistenceDatabase;
    diag_log format ["Persistence load inventory result:%1",_bool];
    hint format ["Inventory Loaded: %1",_bool];
};

stwf_persistInventoryAction= {
//STWPERSISTINVENTORYSAVE=[(name player)];
//publicVariableServer "STWPERSISTINVENTORYSAVE";
    _stwPersistenceDatabase = ["new", "profile"] call OO_PDW;
    _bool = ["saveInventory", ["PersistedInventory", player]] call _stwPersistenceDatabase;
    diag_log format ["Persistence save inventory result:%1",_bool];
    hint format ["Inventory Saved: %1",_bool];
    null=[player] execVm "persistence\sendUnitLoadoutCodeToServer.sqf";
};

stwf_persistPositionAction= {
    STWPERSISTSTATUSSAVE=[(name player)];
    publicVariableServer "STWPERSISTSTATUSSAVE";
    hint format ["Position Saved"];
};

stwf_loadPositionAction= {
    _checkCode=["Clearance code",[STWG_Load_Position_Access_Code]] call stwf_checkKeyPadValue;
    if (!_checkCode) exitwith{false};
    STWPERSISTSTATUSLOAD=[(name player)];
    publicVariableServer "STWPERSISTSTATUSLOAD";
    hint format ["Position Loaded"];
};

stwf_requestCASAction= {
    _checkCode=["Clearance code",[STWG_Request_CAS_Access_Code]] call stwf_checkKeyPadValue;
    if (!_checkCode) exitwith{false};
//if (toUpper(name player) in STW_REQUEST_CAS_ALLOWED_PLAYERS) then
//{
    private["_maxDist","_lock","_num"];
    _maxDist = 700;
    _lock = false;
    _num = 2;
    _vehName = name player;
    //HOW TO :null = [this, 500, true, 2] execVM "JWC_CASFS\addAction.sqf"
    settingsCAS = [player,player,1,[_maxDist,_lock,_num,_vehName],-1, false, true, ""];
    settingsCAS execVm "JWC_CASFS\casMenu.sqf";
//};
};

stwf_skipMissionAsSucessfulAction= {
    _checkCode=["Clearance code",[STWG_Skip_Mission_Success_Access_Code]] call stwf_checkKeyPadValue;
    if (!_checkCode) exitwith{false};
    currentTask player setTaskState "Succeeded";
    ["Task successful","hint",true,false,false] call BIS_fnc_MP;
};

bulletCamHdl=nil;
stwf_activateBulletCam= {
    if (isNil "bulletCamHdl") then
    {
        bulletCamHdl=player addEventHandler ["Fired",
        {
            _null = _this spawn {
                _missile = _this select 6;
                _cam = "camera" camCreate (position player);
                _cam cameraEffect ["External", "Back"];
                waitUntil {
                    if (isNull _missile) exitWith {true};
                    _cam camSetTarget _missile;
                    _cam camSetRelPos [0,-3,0];
                    _cam camCommit 0;
                };
                sleep 0.4;
                _cam cameraEffect ["Terminate", "Back"];
                camDestroy _cam;
                player removeEventHandler ["Fired", bulletCamHdl];
                bulletCamHdl=nil;
            };
        }];
    } else {
        player removeEventHandler ["Fired", bulletCamHdl];
        bulletCamHdl=nil;
    };
};

menu = [
           [ "STW Menu", {}, [], -1, false, false, "", "" ],
           [
               [ "Teleport to base.", {[] call stwf_teleportToBaseAction}, [], -1, false, false, "", "" ],
               [ "Open Arsenal", {[] call stwf_requestArsenalAction}, [], -1, false, false, "", "" ],
               [ "Persistence", {}, [], -1, false, false, "", "" ],
               [
                   [ "Load Inventory", {[] call stwf_loadInventoryAction}, [], -1, false, false, "", "" ],
                   [ "Save Inventory", {[] call stwf_persistInventoryAction}, [], -1, false, false, "", "" ],
                   [ "Load Position", {[] call stwf_loadPositionAction}, [], -1, false, false, "", "" ],
                   [ "Save Position", {[] call stwf_persistPositionAction}, [], -1, false, false, "", "" ]
               ],
               [ "Request CAS", {[] call stwf_requestCASAction}, [], -1, false, false, "", "" ],
               [ "Skip Mision", {[] call stwf_skipMissionAsSucessfulAction}, [], -1, false, false, "", "" ],
               [ "Bulletcam on next shot", {[] call stwf_activateBulletCam}, [], -1, false, false, "", "" ]
           ]
       ];

removeAllActions player;
[ menu, player, false, 5, [ false, true, true, false ] ] call LARs_fnc_menuStart;

/*
if (isNil "STWACTIONS") then
{

	// ADD ACE ACTION
	_action = ["ScienceTechWorksAction","STW","",{},{true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions"], _action,true] call ace_interact_menu_fnc_addActionToClass;

	// ADD ACE ACTION
	_condition = {
	  true
	};
	_statement = {
		if (STW_ALLOW_TELEPORT) then
		{
			_playerName = name player;
			_msg= format ["%1 is being teleported to base.",_playerName];
			[-1, {player globalChat _this}, _msg] call CBA_fnc_globalExecute;
			_stwBaseHqPos= getMarkerPos "marker_STWBASEHQ";
			player setPos(_stwBaseHqPos);
		} else
		{
			_playerName = name player;
			_msg= format ["%1 is requesting teleport.",_playerName];
			[-1, {player globalChat _this}, _msg] call CBA_fnc_globalExecute;
		};
	};
	_action = ["TeleportAction","Teleport to base","",_statement,_condition] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction"], _action] call ace_interact_menu_fnc_addActionToClass;

	// ADD ACE ACTION
	_condition= {true};
	_statement={
					if (STW_ALLOW_ARSENAL) then
					{
						_playerName = name player;
						_msg= format ["%1 is opening the arsenal.",_playerName];
						[-1, {player globalChat _this}, _msg] call CBA_fnc_globalExecute;
						["Open",true] spawn BIS_fnc_arsenal;
					} else
					{
					  _playerName = name player;
					  _msg= format ["%1 is requesting the arsenal.",_playerName];
					  [-1, {player globalChat _this}, _msg] call CBA_fnc_globalExecute;
					};
				};
	_action = ["ArsenalAction","Arsenal","",_statement,_condition] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction"], _action] call ace_interact_menu_fnc_addActionToClass;

	// PERSISTENCE MENU
	_condition= {true};
	_statement={
				};
	_action = ["PersistenceAction","Persistence","",_statement,_condition] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction"], _action] call ace_interact_menu_fnc_addActionToClass;

	// ADD ACE ACTION
	_condition= {true};
	_statement={
					//STWPERSISTINVENTORYSAVE=[(name player)];
					//publicVariableServer "STWPERSISTINVENTORYSAVE";
					_stwPersistenceDatabase = ["new", "profile"] call OO_PDW;
					_bool = ["saveInventory", ["PersistedInventory", player]] call _stwPersistenceDatabase;
					diag_log format ["Persistence save inventory result:%1",_bool];
					hint format ["Inventory Saved: %1",_bool];
				};
	_action = ["SaveInventory","Save Inventory","",_statement,_condition] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction","PersistenceAction"], _action] call ace_interact_menu_fnc_addActionToClass;


	// ADD ACE ACTION
	_condition= {true};
	_statement={
					removeAllWeapons player;
					removeAllItems player;
					removeAllAssignedItems player;
					removeUniform player;
					removeVest player;
					removeBackpack player;
					removeHeadgear player;
					removeGoggles player;
					//STWPERSISTINVENTORYLOAD=[(name player)];
					//publicVariableServer "STWPERSISTINVENTORYLOAD";
					_stwPersistenceDatabase = ["new", "profile"] call OO_PDW;
					_bool = ["loadInventory", ["PersistedInventory", player]] call _stwPersistenceDatabase;
					diag_log format ["Persistence load inventory result:%1",_bool];
					hint format ["Inventory Loaded: %1",_bool];
				};
	_action = ["LoadInventory","Load Inventory","",_statement,_condition] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction","PersistenceAction"], _action] call ace_interact_menu_fnc_addActionToClass;

	// ADD ACE ACTION
	_condition= {true};
	_statement={
					STWPERSISTSTATUSSAVE=[(name player)];
					publicVariableServer "STWPERSISTSTATUSSAVE";
					hint format ["Status Saved"];
				};
	_action = ["SaveStatus","Save Status","",_statement,_condition] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction","PersistenceAction"], _action] call ace_interact_menu_fnc_addActionToClass;

	// ADD ACE ACTION
	_condition= {true};
	_statement={
					STWPERSISTSTATUSLOAD=[(name player)];
					publicVariableServer "STWPERSISTSTATUSLOAD";
					hint format ["Status Loaded"];
				};
	_action = ["LoadStatus","Load Status","",_statement,_condition] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction","PersistenceAction"], _action] call ace_interact_menu_fnc_addActionToClass;


	if (toUpper(name player) in STW_REQUEST_CAS_ALLOWED_PLAYERS) then
	{
		// ADD ACE ACTION
		_condition= {true};
		_statement={
					private["_maxDist","_lock","_num"];
					_maxDist = 700;
					_lock = false;
					_num = 2;
					_vehName = name player;
					//HOW TO :null = [this, 500, true, 2] execVM "JWC_CASFS\addAction.sqf"
					settingsCAS = [player,player,1,[_maxDist,_lock,_num,_vehName],-1, false, true, ""];
					settingsCAS execVm "JWC_CASFS\casMenu.sqf";
					};
		_action = ["RequestCAS","Request CAS","",_statement,_condition] call ace_interact_menu_fnc_createAction;
		[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction"], _action] call ace_interact_menu_fnc_addActionToClass;

		// ADD ACE ACTION
		_condition= {true};
		_statement={
					currentTask player setTaskState "Succeeded";
					["Task successful","hint",true,false,false] call BIS_fnc_MP;
					};
		_action = ["MissionSucessful","Mission Sucessful","",_statement,_condition] call ace_interact_menu_fnc_createAction;
		[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction"], _action] call ace_interact_menu_fnc_addActionToClass;
	};


	// ADD ACE ACTION
	bulletCamHdl=nil;
	_condition= {isNil "bulletCamHdl"};
	_statement={
					if (isNil "bulletCamHdl") then
					{
						bulletCamHdl=player addEventHandler ["Fired",
						{
							_null = _this spawn {
								_missile = _this select 6;
								_cam = "camera" camCreate (position player);
								_cam cameraEffect ["External", "Back"];
								waitUntil {
									if (isNull _missile) exitWith {true};
									_cam camSetTarget _missile;
									_cam camSetRelPos [0,-3,0];
									_cam camCommit 0;
								};
								sleep 0.4;
								_cam cameraEffect ["Terminate", "Back"];
								camDestroy _cam;
								player removeEventHandler ["Fired", bulletCamHdl];
								bulletCamHdl=nil;
							};
						}];
					 } else
					 {
						player removeEventHandler ["Fired", bulletCamHdl];
						bulletCamHdl=nil;
					 };
				};
	_action = ["BulletCamAction","Bullet Cam On","",_statement,_condition] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction"], _action] call ace_interact_menu_fnc_addActionToClass;

};


if ((name player)=="Cpt Horny") then
{
	if (isNil "STWACTIONS") then
	{

		/////////////////////////////////////////
		// ADD ACE ACTION
		_condition= {true};
		_statement={
					};
		_action = ["AllowAction","Allowances","",_statement,_condition] call ace_interact_menu_fnc_createAction;
		[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction"], _action] call ace_interact_menu_fnc_addActionToClass;

		// ADD ACE ACTION
		_condition = {
		  true
		};
		_statement = {
			STW_ALLOW_ARSENAL=!STW_ALLOW_ARSENAL;
			publicVariable "STW_ALLOW_ARSENAL";
			_msg= format ["Arsenal allowed: %1",STW_ALLOW_ARSENAL];
			hint _msg;
		};
		_action = ["AllowArsenalAction","Allow Arsenal","",_statement,_condition] call ace_interact_menu_fnc_createAction;
		[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction","AllowAction"], _action] call ace_interact_menu_fnc_addActionToClass;

		// ADD ACE ACTION
		_condition = {
		  true
		};
		_statement = {
			STW_ALLOW_TELEPORT=!STW_ALLOW_TELEPORT;
			publicVariable "STW_ALLOW_TELEPORT";
			_msg= format ["Teleport allowed: %1",STW_ALLOW_TELEPORT];
			hint _msg;
		};
		_action = ["AllowTeleportAction","Allow Teleport","",_statement,_condition] call ace_interact_menu_fnc_createAction;
		[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction","AllowAction"], _action] call ace_interact_menu_fnc_addActionToClass;


		// ADD ACE ACTION
		_condition = {
		  true
		};
		_statement = {
			call STWFAddFlashLightToEnemyUnits;
		};
		_action = ["GiveFlashLightsToEnemiesAction","Enemies FlashLights","",_statement,_condition] call ace_interact_menu_fnc_createAction;
		[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction","AllowAction"], _action] call ace_interact_menu_fnc_addActionToClass;

		// ADD ACE ACTION
		_condition = {
		  true
		};
		_statement = {
			call STWFAddNightVisionToEnemyUnits;
		};
		_action = ["GiveNVGooglesToEnemiesAction","Enemies NVGoogles","",_statement,_condition] call ace_interact_menu_fnc_createAction;
		[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction","AllowAction"], _action] call ace_interact_menu_fnc_addActionToClass;


		// ADD ACE ACTION
		_condition = {
		  true
		};
		_statement = {
			call STWFAddNightVisionToFriendUnits;
		};
		_action = ["GiveNVGooglesToFriendsAction","Friends NVGoogles","",_statement,_condition] call ace_interact_menu_fnc_createAction;
		[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction","AllowAction"], _action] call ace_interact_menu_fnc_addActionToClass;

		// ADD ACE ACTION
		_condition = {
		  true
		};
		_statement = {
			call STWFAddFlashLightToFriendUnits;
		};
		_action = ["GiveFlashLightsToFriendsAction","Friends FlashLights","",_statement,_condition] call ace_interact_menu_fnc_createAction;
		[(typeOf player), 1, ["ACE_SelfActions","ScienceTechWorksAction","AllowAction"], _action] call ace_interact_menu_fnc_addActionToClass;

	}; // ENDIF IS NIL STWACTIONS

	if (isNil "STWACTIONS") then
	{
		STWACTIONS=["INSTALLED"];
	};


};


*/

