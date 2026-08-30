# /trigger chunkslot set <key>
# Frees one of the player's claims from anywhere in the world.
#
# Reachable only by clicking [free] in the /trigger chunks menu, so players
# never have to know this trigger exists. The key packs the menu generation and
# the row number together: key = generation * 100 + row.
#
# The score is read BEFORE the reset, since the reset zeroes it.
execute store result score #key cl.tmp run scoreboard players get @s chunkslot
function chunkloader:util/reset_slot

scoreboard players operation #gen_in cl.tmp = #key cl.tmp
scoreboard players operation #gen_in cl.tmp /= #100 cl.tmp
scoreboard players operation #n cl.tmp = #key cl.tmp
scoreboard players operation #n cl.tmp %= #100 cl.tmp

# A key from a stale menu points at a row number that has since shifted, so
# acting on it would free a chunk the player did not click. Refuse and reprint.
execute unless score #gen_in cl.tmp = @s cl.gen run function chunkloader:msg/stale_menu
execute unless score #gen_in cl.tmp = @s cl.gen run return run function chunkloader:trigger/list

function chunkloader:util/owner
execute if data storage chunkloader:tmp target run data remove storage chunkloader:tmp target

scoreboard players set #idx cl.tmp 0
data modify storage chunkloader:tmp iter set from storage chunkloader:data claims
execute if data storage chunkloader:tmp iter[0] run function chunkloader:internal/slot_step

execute unless data storage chunkloader:tmp target run function chunkloader:msg/bad_slot
execute unless data storage chunkloader:tmp target run return run function chunkloader:trigger/list

function chunkloader:internal/remove_apply with storage chunkloader:tmp target
function chunkloader:util/count_owned
function chunkloader:internal/slot_confirm with storage chunkloader:tmp target
function chunkloader:trigger/list
