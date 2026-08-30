# Community Chunk Loader - startup / reload entry point.
# Runs on every server start AND every /reload.

# --- setup and migrations -----------------------------------------------
# setup_version records which objectives this world already has. The first
# release recorded a bare setup_done flag instead, so those worlds are stamped
# as version 1 here and then migrated forward. Without this, an upgraded server
# would never gain objectives added after its original install.
execute if data storage chunkloader:data setup_done unless data storage chunkloader:data setup_version run data modify storage chunkloader:data setup_version set value 1
execute unless data storage chunkloader:data setup_version run function chunkloader:setup
execute if data storage chunkloader:data {setup_version:1} run function chunkloader:migrate/v2

# --- constants ----------------------------------------------------------
# Safe to re-set every load; setting an existing score never errors.
scoreboard players set #16 cl.tmp 16
scoreboard players set #100 cl.tmp 100
scoreboard players set #1000000 cl.tmp 1000000

# --- configuration ------------------------------------------------------
# Only seeded when unset, so admin changes survive /reload and restart.
execute unless score #max_chunks cl.cfg matches -2147483648.. run scoreboard players set #max_chunks cl.cfg 4
execute unless score #claims_enabled cl.cfg matches -2147483648.. run scoreboard players set #claims_enabled cl.cfg 1
execute unless score #dim_overworld cl.cfg matches -2147483648.. run scoreboard players set #dim_overworld cl.cfg 1
execute unless score #dim_nether cl.cfg matches -2147483648.. run scoreboard players set #dim_nether cl.cfg 1
execute unless score #dim_end cl.cfg matches -2147483648.. run scoreboard players set #dim_end cl.cfg 1

# --- persistent storage -------------------------------------------------
execute unless data storage chunkloader:data claims run data modify storage chunkloader:data claims set value []
execute if data storage chunkloader:tmp iter run data remove storage chunkloader:tmp iter
execute if data storage chunkloader:tmp entry run data remove storage chunkloader:tmp entry

# --- housekeeping -------------------------------------------------------
# Clear any probe marker orphaned by a crash mid-command.
execute if entity @e[type=marker,tag=cl_probe] run kill @e[type=marker,tag=cl_probe]

# Push every online player back through init so trigger access is re-granted.
# This makes /reload a repair action rather than something that can strand a
# player with a disabled trigger.
scoreboard players reset * cl.init

# Re-assert forceloads for every stored claim. Idempotent; also recovers from
# a manual "/forceload remove all" or a lost chunks.dat.
function chunkloader:admin/reconcile
