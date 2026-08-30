# Macro args: owner
# Row numbering and the click key have to make the trip through storage:
# macros substitute from NBT, never from scoreboards.
$execute if data storage chunkloader:tmp {ctx:{owner:$(owner)}} run scoreboard players add #idx cl.tmp 1
$execute if data storage chunkloader:tmp {ctx:{owner:$(owner)}} run function chunkloader:internal/list_key
$execute if data storage chunkloader:tmp {ctx:{owner:$(owner)}} run function chunkloader:internal/list_print with storage chunkloader:tmp entry
