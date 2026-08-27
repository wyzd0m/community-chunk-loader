# Macro args: owner
# Route matching entries through the normal remove path so shared-chunk
# ownership is still honoured.
$execute if data storage chunkloader:tmp {ctx:{owner:$(owner)}} run function chunkloader:internal/remove_apply with storage chunkloader:tmp entry
$execute if data storage chunkloader:tmp {ctx:{owner:$(owner)}} run scoreboard players add #cleared cl.tmp 1
