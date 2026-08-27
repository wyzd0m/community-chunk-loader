data modify storage chunkloader:tmp entry set from storage chunkloader:tmp iter[0]
data remove storage chunkloader:tmp iter[0]
function chunkloader:internal/listall_entry with storage chunkloader:tmp entry
execute if data storage chunkloader:tmp iter[0] run function chunkloader:internal/listall_step
