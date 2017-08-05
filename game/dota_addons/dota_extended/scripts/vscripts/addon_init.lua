if IsClient() then	-- Load clientside utility lib
	require("/libraries/client_util")

	--Load ability KVs
	AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
    EXTENDED_GENERIC_TALENT_LIST = LoadKeyValues("scripts/npc/KV/extended_generic_talent_list.kv")
end