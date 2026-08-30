# /trigger cl_list set 1
# Prints the player's claims as a clickable menu: a [free] button per row and
# a claim button underneath. This is the only command a player needs to know.
function chunkloader:util/reset_list

# Bump this player's menu generation so buttons from any earlier printout stop
# working. Wrapped well below int max so gen*100 can never overflow.
scoreboard players add @s cl.gen 1
scoreboard players operation @s cl.gen %= #1000000 cl.tmp
scoreboard players operation #gen cl.tmp = @s cl.gen

function chunkloader:util/owner
function chunkloader:util/count_owned
function chunkloader:msg/list_header

scoreboard players set #idx cl.tmp 0
data modify storage chunkloader:tmp iter set from storage chunkloader:data claims
execute if data storage chunkloader:tmp iter[0] run function chunkloader:internal/list_step

execute if score #used cl.tmp matches 0 run function chunkloader:msg/list_empty
function chunkloader:msg/list_footer
