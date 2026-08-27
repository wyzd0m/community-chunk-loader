# /trigger cl_add set 1
# Claims the chunk the player is currently standing in.
function chunkloader:util/reset_add

execute unless score #claims_enabled cl.cfg matches 1 run return run function chunkloader:msg/disabled

function chunkloader:util/context
execute unless score #dim_ok cl.tmp matches 1 run return run function chunkloader:msg/bad_dim

function chunkloader:util/count_owned
execute if score #used cl.tmp >= #max_chunks cl.cfg run return run function chunkloader:msg/limit

scoreboard players set #flag cl.tmp 0
function chunkloader:internal/check_owned with storage chunkloader:tmp ctx
execute if score #flag cl.tmp matches 1 run return run function chunkloader:msg/dup

function chunkloader:internal/add_apply with storage chunkloader:tmp ctx
scoreboard players add #used cl.tmp 1
function chunkloader:msg/added
