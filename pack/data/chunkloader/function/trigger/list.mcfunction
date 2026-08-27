# /trigger cl_list set 1
function chunkloader:util/reset_list

function chunkloader:util/owner
function chunkloader:util/count_owned
function chunkloader:msg/list_header

scoreboard players set #idx cl.tmp 0
data modify storage chunkloader:tmp iter set from storage chunkloader:data claims
execute if data storage chunkloader:tmp iter[0] run function chunkloader:internal/list_step

execute if score #used cl.tmp matches 0 run function chunkloader:msg/list_empty
