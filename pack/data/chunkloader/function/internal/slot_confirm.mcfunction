# Macro args: dname, cx, cz
# Names the chunk that was freed: the player clicked a button rather than
# standing somewhere, so "Claim removed" alone would be ambiguous.
$tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"Freed ","color":"green"},{"text":"$(dname) chunk X $(cx), Z $(cz)","color":"white"},{"text":".","color":"green"}]
tellraw @s [{"text":"  Now using ","color":"gray"},{"score":{"name":"#used","objective":"cl.tmp"},"color":"yellow"},{"text":" / ","color":"gray"},{"score":{"name":"#max_chunks","objective":"cl.cfg"},"color":"yellow"},{"text":" slots.","color":"gray"}]
