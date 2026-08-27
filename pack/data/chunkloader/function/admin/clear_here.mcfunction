# /function chunkloader:admin/clear_here   (stand in the chunk)
# Removes ALL claims on the current chunk regardless of owner, then unloads it.
# This is the offline-player escape hatch: you know where the farm is.
function chunkloader:util/context
execute if data storage chunkloader:tmp {ctx:{dim:"unsupported"}} run return run tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"This dimension is not managed by the chunk loader.","color":"red"}]

scoreboard players set #flag cl.tmp 0
function chunkloader:internal/clear_here_check with storage chunkloader:tmp ctx
execute if score #flag cl.tmp matches 0 run return run tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"No claims are registered on this chunk.","color":"yellow"}]

function chunkloader:internal/clear_here_purge with storage chunkloader:tmp ctx
function chunkloader:internal/clear_here_unload with storage chunkloader:tmp ctx
tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"All claims on this chunk have been cleared and the chunk unloaded.","color":"green"}]
