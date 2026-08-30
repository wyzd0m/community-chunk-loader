# Macro args: dname, cx, cz
# Names the chunk that was freed: the player clicked a button rather than
# standing somewhere, so "Claim removed" alone would be ambiguous.
$tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"Freed ","color":"green"},{"text":"$(dname) chunk X $(cx), Z $(cz)","color":"white"},{"text":".","color":"green"}]
