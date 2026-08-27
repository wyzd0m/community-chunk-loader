# Macro args: owner, dim, cx, cz
# Sets #flag to 1 if this exact player already owns this exact chunk.
$execute if data storage chunkloader:data claims[{owner:$(owner),dim:"$(dim)",cx:$(cx),cz:$(cz)}] run scoreboard players set #flag cl.tmp 1
