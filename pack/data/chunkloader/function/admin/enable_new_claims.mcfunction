# /function chunkloader:admin/enable_new_claims
scoreboard players set #claims_enabled cl.cfg 1
tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"New claims enabled.","color":"green"}]
