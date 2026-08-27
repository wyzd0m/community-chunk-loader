# Build storage chunkloader:tmp ctx = {owner, dim, dname, cx, cz, bx, bz}
# and set #dim_ok to whether this dimension currently accepts new claims.
#
# Dimension identity is resolved separately from the config gate so that a
# player can still REMOVE a claim in a dimension an admin has since disabled.

data modify storage chunkloader:tmp ctx set value {dim:"unsupported",dname:"Unsupported"}
data modify storage chunkloader:tmp ctx.owner set from entity @s UUID
scoreboard players set #dim_ok cl.tmp 0

execute if dimension minecraft:overworld run data modify storage chunkloader:tmp ctx merge value {dim:"minecraft:overworld",dname:"Overworld"}
execute if dimension minecraft:overworld run scoreboard players operation #dim_ok cl.tmp = #dim_overworld cl.cfg
execute if dimension minecraft:the_nether run data modify storage chunkloader:tmp ctx merge value {dim:"minecraft:the_nether",dname:"Nether"}
execute if dimension minecraft:the_nether run scoreboard players operation #dim_ok cl.tmp = #dim_nether cl.cfg
execute if dimension minecraft:the_end run data modify storage chunkloader:tmp ctx merge value {dim:"minecraft:the_end",dname:"The End"}
execute if dimension minecraft:the_end run scoreboard players operation #dim_ok cl.tmp = #dim_end cl.cfg

function chunkloader:util/get_chunk

execute store result storage chunkloader:tmp ctx.cx int 1 run scoreboard players get #cx cl.tmp
execute store result storage chunkloader:tmp ctx.cz int 1 run scoreboard players get #cz cl.tmp
execute store result storage chunkloader:tmp ctx.bx int 1 run scoreboard players get #bx cl.tmp
execute store result storage chunkloader:tmp ctx.bz int 1 run scoreboard players get #bz cl.tmp
