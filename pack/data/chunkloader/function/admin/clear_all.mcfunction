# /function chunkloader:admin/clear_all
# Targeted teardown: unloads exactly the chunks this datapack force-loaded and
# wipes the claim list. Does NOT touch forceloads created by anything else.
data modify storage chunkloader:tmp iter set from storage chunkloader:data claims
data modify storage chunkloader:data claims set value []
execute if data storage chunkloader:tmp iter[0] run function chunkloader:internal/unload_step
tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"All datapack-managed claims cleared and unloaded.","color":"yellow"}]
