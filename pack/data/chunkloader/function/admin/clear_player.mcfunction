# /execute as <PlayerName> run function chunkloader:admin/clear_player
# Removes every claim owned by the executing player, honouring shared chunks.
# The player must be online (a datapack cannot resolve an offline name to a UUID).
scoreboard players set #cleared cl.tmp 0
function chunkloader:util/owner
data modify storage chunkloader:tmp iter set from storage chunkloader:data claims
execute if data storage chunkloader:tmp iter[0] run function chunkloader:internal/clearp_step
tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"Cleared ","color":"yellow"},{"score":{"name":"#cleared","objective":"cl.tmp"},"color":"white"},{"text":" claim(s) for this player.","color":"yellow"}]
