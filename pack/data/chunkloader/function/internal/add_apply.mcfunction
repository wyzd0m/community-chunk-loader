# Macro args: owner, dim, dname, cx, cz, bx, bz
# Shared ownership without a refcount: the claim list IS the refcount. Only
# force-load when nobody else already holds this chunk.
$execute unless data storage chunkloader:data claims[{dim:"$(dim)",cx:$(cx),cz:$(cz)}] in $(dim) run forceload add $(bx) $(bz)
$data modify storage chunkloader:data claims append value {owner:$(owner),dim:"$(dim)",dname:"$(dname)",cx:$(cx),cz:$(cz),bx:$(bx),bz:$(bz)}
