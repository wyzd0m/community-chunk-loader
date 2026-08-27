# Macro args: dim, cx, cz
$execute if data storage chunkloader:data claims[{dim:"$(dim)",cx:$(cx),cz:$(cz)}] run scoreboard players set #flag cl.tmp 1
