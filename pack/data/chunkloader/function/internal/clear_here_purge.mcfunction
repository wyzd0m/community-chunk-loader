# Macro args: dim, cx, cz
# "data remove" on a filtered list path is looped rather than trusted to strip
# every match in one pass.
$data remove storage chunkloader:data claims[{dim:"$(dim)",cx:$(cx),cz:$(cz)}]
$execute if data storage chunkloader:data claims[{dim:"$(dim)",cx:$(cx),cz:$(cz)}] run function chunkloader:internal/clear_here_purge with storage chunkloader:tmp ctx
