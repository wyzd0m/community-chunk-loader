# /function chunkloader:admin/set_limit {n:4}
# Lowering the limit never deletes existing claims. Players over the new limit
# simply cannot add more until they drop below it.
$scoreboard players set #max_chunks cl.cfg $(n)
$tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"Per-player limit set to $(n).","color":"green"}]
