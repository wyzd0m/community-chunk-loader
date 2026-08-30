# Community Chunk Loader - tick dispatcher.
# Deliberately tiny: a handful of score-filtered selectors and nothing else.
# All real work happens only when a player actually fires a trigger.

execute as @a unless score @s cl.init matches 1 run function chunkloader:player/join

execute as @a[scores={cl_add=1..}] at @s run function chunkloader:trigger/add
execute as @a[scores={cl_remove=1..}] at @s run function chunkloader:trigger/remove
execute as @a[scores={cl_list=1..}] run function chunkloader:trigger/list
execute as @a[scores={cl_slot=1..}] run function chunkloader:trigger/slot

# A player can run "/trigger cl_add set -5"; swallow it and re-arm.
execute as @a[scores={cl_add=..-1}] run function chunkloader:util/reset_add
execute as @a[scores={cl_remove=..-1}] run function chunkloader:util/reset_remove
execute as @a[scores={cl_list=..-1}] run function chunkloader:util/reset_list
execute as @a[scores={cl_slot=..-1}] run function chunkloader:util/reset_slot
