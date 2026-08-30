# v2 -> v3: renames the player-facing triggers so the menu is reachable as
# /trigger chunks. Old objectives are dropped rather than left behind, so
# tab-completing "/trigger " shows one coherent set of names instead of two.
#
# Any pending trigger value a player had is discarded with the old objective.
# That is harmless: values are consumed on the tick they are set.
scoreboard objectives add chunks trigger
scoreboard objectives add chunkadd trigger
scoreboard objectives add chunkfree trigger
scoreboard objectives add chunkslot trigger

scoreboard objectives remove cl_list
scoreboard objectives remove cl_add
scoreboard objectives remove cl_remove
scoreboard objectives remove cl_slot

data modify storage chunkloader:data setup_version set value 3
