data modify storage chunkloader:tmp entry set from storage chunkloader:tmp iter[0]
data remove storage chunkloader:tmp iter[0]
function chunkloader:internal/slot_match with storage chunkloader:tmp entry
execute if data storage chunkloader:tmp iter[0] run function chunkloader:internal/slot_step
