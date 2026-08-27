# /function chunkloader:admin/list_all    (run as a player)
# Owner is printed as the raw UUID int array. Cross-reference it against the
# server's usercache.json / logs when you need to identify an offline player.
scoreboard players set #total cl.tmp 0
execute if data storage chunkloader:data claims[0] store result score #total cl.tmp run data get storage chunkloader:data claims
tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"All claims (","color":"white"},{"score":{"name":"#total","objective":"cl.tmp"},"color":"yellow"},{"text":")","color":"white"}]
data modify storage chunkloader:tmp iter set from storage chunkloader:data claims
execute if data storage chunkloader:tmp iter[0] run function chunkloader:internal/listall_step
