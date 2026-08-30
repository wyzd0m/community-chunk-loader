# /trigger chunkfree set 1
# Releases this player's claim on the chunk they are standing in.
# Intentionally NOT gated on #claims_enabled: players must always be able to
# free a slot, even while an admin has new claims switched off.
function chunkloader:util/reset_remove

function chunkloader:util/context
execute if data storage chunkloader:tmp {ctx:{dim:"unsupported"}} run return run function chunkloader:msg/bad_dim_remove

scoreboard players set #flag cl.tmp 0
function chunkloader:internal/check_owned with storage chunkloader:tmp ctx
execute if score #flag cl.tmp matches 0 run return run function chunkloader:msg/not_owned

function chunkloader:internal/remove_apply with storage chunkloader:tmp ctx
function chunkloader:util/count_owned
function chunkloader:msg/removed
