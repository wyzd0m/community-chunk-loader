# /function chunkloader:admin/panic
# LAST RESORT. Runs "forceload remove all" in every vanilla dimension, which
# also destroys forceloads this datapack did not create, then wipes the claim
# list and blocks new claims. Prefer admin/clear_all unless the state is broken.
execute in minecraft:overworld run forceload remove all
execute in minecraft:the_nether run forceload remove all
execute in minecraft:the_end run forceload remove all
data modify storage chunkloader:data claims set value []
scoreboard players set #claims_enabled cl.cfg 0
tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"PANIC: every forceload in the overworld, nether and end was removed. All claims wiped. New claims are now disabled.","color":"red"}]
