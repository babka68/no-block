#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =  {
	name = "No Block", 
	author = "sslice, babka68", 
	description = "Плагин позволяет игрокам проходить друг друга на сквозь", 
	version = "1.1", 
	url = "https://vk.com/zakazserver68", 
};

int g_ioffsCollisionGroup;
bool g_bHooked;
Handle g_hnoBlock;

public void OnPluginStart() {
	g_ioffsCollisionGroup = FindSendPropInfo("CBaseEntity", "m_CollisionGroup");
	if (g_ioffsCollisionGroup == -1) {
		g_bHooked = false;
		PrintToServer("* FATAL ERROR: Failed to get offset for CBaseEntity::m_CollisionGroup");
	}
	else {
		g_bHooked = true;
		HookEvent("player_spawn", OnSpawn, EventHookMode_Post);
		g_hnoBlock = CreateConVar("sm_noblock", "1", "1 - Включить,0 - Отключить столкновение с игроками.", FCVAR_REPLICATED);
		HookConVarChange(g_hnoBlock, OnConVarChange);
	}
}

public void OnConVarChange(Handle hCvar, const char[] Value, const char[] intValue) {
	int value = !!StringToInt(intValue);
	if (value == 0)
	{
		if (g_bHooked == true) {
			g_bHooked = false;
			UnhookEvent("player_spawn", OnSpawn, EventHookMode_Post);
		}
	}
	else {
		g_bHooked = true;
		HookEvent("player_spawn", OnSpawn, EventHookMode_Post);
	}
}

public void OnSpawn(Event event, const char[] name, bool dontBroadcast) {
	int userid = event.GetInt("userid");
	int entity = GetClientOfUserId(userid);
	SetEntData(entity, g_ioffsCollisionGroup, 2, 4, true);
} 
