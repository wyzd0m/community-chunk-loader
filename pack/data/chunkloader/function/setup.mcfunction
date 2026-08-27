# One-time objective creation.
#
# Guarded by storage rather than run every load: "scoreboard objectives add" on
# an existing objective throws, and a function-level throw is logged to the
# server console. Running it unconditionally would print red errors on every
# single /reload, which is exactly the noise that teaches an admin to ignore
# their console.
#
# To force this to run again (e.g. an objective was deleted by hand):
#   /data remove storage chunkloader:data setup_done
#   /reload

scoreboard objectives add cl.tmp dummy
scoreboard objectives add cl.cfg dummy
scoreboard objectives add cl.init dummy
scoreboard objectives add cl_add trigger
scoreboard objectives add cl_remove trigger
scoreboard objectives add cl_list trigger

data modify storage chunkloader:data setup_done set value 1b
