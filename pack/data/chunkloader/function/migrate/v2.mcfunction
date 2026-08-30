# v1 -> v2: adds the cl_slot trigger backing the [free] buttons in the
# /trigger cl_list menu. Without this, an existing install would keep working
# but every [free] button would silently do nothing.
scoreboard objectives add cl_slot trigger
scoreboard objectives add cl.gen dummy

execute if data storage chunkloader:data setup_done run data remove storage chunkloader:data setup_done
data modify storage chunkloader:data setup_version set value 2
