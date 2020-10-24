_STWFInstallRespawnHandlersOnPlayer={
		if (!local player) exitWith{};
		waituntil { alive player };		
		player addEventHandler ["Respawn", {player execVM "STW_OnRespawn.sqf"}];
};
 
[] call _STWFInstallRespawnHandlersOnPlayer;
