# Macro args: owner, dim, cx, cz, bx, bz
# Drop this owner's claim, then unload only if no other owner remains.
$data remove storage chunkloader:data claims[{owner:$(owner),dim:"$(dim)",cx:$(cx),cz:$(cz)}]
$execute unless data storage chunkloader:data claims[{dim:"$(dim)",cx:$(cx),cz:$(cz)}] in $(dim) run forceload remove $(bx) $(bz)
