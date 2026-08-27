# /function chunkloader:admin/disable_new_claims
# Stops new claims. Existing claims stay loaded, and players can still remove.
scoreboard players set #claims_enabled cl.cfg 0
tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"New claims disabled. Existing claims are untouched.","color":"yellow"}]
