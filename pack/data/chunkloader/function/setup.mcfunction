# One-time objective creation for a FRESH install.
#
# Guarded by storage rather than run every load: "scoreboard objectives add" on
# an existing objective throws, and a function-level throw is logged to the
# server console. Running it unconditionally would print red errors on every
# single /reload, which is exactly the noise that teaches an admin to ignore
# their console.
#
# Adding an objective in a later release? Do NOT just add it here - existing
# worlds have already run this function and will never run it again. Add a
# migrate/vN function and bump setup_version, or the new objective simply will
# not exist on any server that already installed the pack.

scoreboard objectives add cl.tmp dummy
scoreboard objectives add cl.cfg dummy
scoreboard objectives add cl.init dummy
scoreboard objectives add chunkadd trigger
scoreboard objectives add chunkfree trigger
scoreboard objectives add chunks trigger
scoreboard objectives add chunkslot trigger
scoreboard objectives add cl.gen dummy

data modify storage chunkloader:data setup_version set value 3
