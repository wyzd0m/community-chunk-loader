# /function chunkloader:admin/status      (run as a player)
scoreboard players set #total cl.tmp 0
execute if data storage chunkloader:data claims[0] store result score #total cl.tmp run data get storage chunkloader:data claims

tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"Status","color":"white","bold":true}]
tellraw @s [{"text":"  Total claims: ","color":"gray"},{"score":{"name":"#total","objective":"cl.tmp"},"color":"yellow"}]
tellraw @s [{"text":"  Limit per player: ","color":"gray"},{"score":{"name":"#max_chunks","objective":"cl.cfg"},"color":"yellow"}]
execute if score #claims_enabled cl.cfg matches 1 run tellraw @s [{"text":"  New claims: ","color":"gray"},{"text":"enabled","color":"green"}]
execute unless score #claims_enabled cl.cfg matches 1 run tellraw @s [{"text":"  New claims: ","color":"gray"},{"text":"DISABLED","color":"red"}]
tellraw @s [{"text":"  Dimensions:","color":"gray"}]
execute if score #dim_overworld cl.cfg matches 1 run tellraw @s [{"text":"    Overworld: ","color":"gray"},{"text":"allowed","color":"green"}]
execute unless score #dim_overworld cl.cfg matches 1 run tellraw @s [{"text":"    Overworld: ","color":"gray"},{"text":"blocked","color":"red"}]
execute if score #dim_nether cl.cfg matches 1 run tellraw @s [{"text":"    Nether: ","color":"gray"},{"text":"allowed","color":"green"}]
execute unless score #dim_nether cl.cfg matches 1 run tellraw @s [{"text":"    Nether: ","color":"gray"},{"text":"blocked","color":"red"}]
execute if score #dim_end cl.cfg matches 1 run tellraw @s [{"text":"    The End: ","color":"gray"},{"text":"allowed","color":"green"}]
execute unless score #dim_end cl.cfg matches 1 run tellraw @s [{"text":"    The End: ","color":"gray"},{"text":"blocked","color":"red"}]
