# Macro args: owner
# Walks the player's own claims in list order and captures the n-th one.
# Once #idx has passed #n nothing can match again, so the first hit wins.
$execute if data storage chunkloader:tmp {ctx:{owner:$(owner)}} run scoreboard players add #idx cl.tmp 1
$execute if data storage chunkloader:tmp {ctx:{owner:$(owner)}} if score #idx cl.tmp = #n cl.tmp run data modify storage chunkloader:tmp target set from storage chunkloader:tmp entry
