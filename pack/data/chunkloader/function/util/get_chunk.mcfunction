# Resolve the executing player's chunk into #cx/#cz and the chunk-origin block
# into #bx/#bz. Must be run with the player as both @s and the execution anchor.
#
# Why the marker: "data get entity @s Pos[0]" truncates toward zero, so a player
# at x = -0.5 reports 0 instead of -1. "align xyz" floors the execution position
# correctly, so we summon a probe there and read its already-integral Pos.
# Scoreboard "/=" is floor division, so the negative chunk math is also correct.

execute at @s align xyz run summon marker ~ ~ ~ {Tags:["cl_probe"]}
execute store result score #bx cl.tmp run data get entity @e[type=marker,tag=cl_probe,distance=..3,limit=1,sort=nearest] Pos[0] 1
execute store result score #bz cl.tmp run data get entity @e[type=marker,tag=cl_probe,distance=..3,limit=1,sort=nearest] Pos[2] 1
execute if entity @e[type=marker,tag=cl_probe,distance=..3] run kill @e[type=marker,tag=cl_probe,distance=..3]

scoreboard players operation #cx cl.tmp = #bx cl.tmp
scoreboard players operation #cz cl.tmp = #bz cl.tmp
scoreboard players operation #cx cl.tmp /= #16 cl.tmp
scoreboard players operation #cz cl.tmp /= #16 cl.tmp

# Canonical block coordinate for this chunk, so every owner of a shared chunk
# stores the same value and /forceload remove always targets the same column.
scoreboard players operation #bx cl.tmp = #cx cl.tmp
scoreboard players operation #bz cl.tmp = #cz cl.tmp
scoreboard players operation #bx cl.tmp *= #16 cl.tmp
scoreboard players operation #bz cl.tmp *= #16 cl.tmp
