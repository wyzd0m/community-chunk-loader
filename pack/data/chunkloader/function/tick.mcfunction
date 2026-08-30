# Community Chunk Loader - tick dispatcher.
# Deliberately tiny: a handful of score-filtered selectors and nothing else.
# All real work happens only when a player actually fires a trigger.

execute as @a unless score @s cl.init matches 1 run function chunkloader:player/join

execute as @a[scores={chunkadd=1..}] at @s run function chunkloader:trigger/add
execute as @a[scores={chunkfree=1..}] at @s run function chunkloader:trigger/remove
execute as @a[scores={chunks=1..}] run function chunkloader:trigger/list
execute as @a[scores={chunkslot=1..}] run function chunkloader:trigger/slot

# A player can run "/trigger chunkadd set -5"; swallow it and re-arm.
execute as @a[scores={chunkadd=..-1}] run function chunkloader:util/reset_add
execute as @a[scores={chunkfree=..-1}] run function chunkloader:util/reset_remove
execute as @a[scores={chunks=..-1}] run function chunkloader:util/reset_list
execute as @a[scores={chunkslot=..-1}] run function chunkloader:util/reset_slot
