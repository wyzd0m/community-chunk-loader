# Count claims owned by ctx.owner into #used.
# Recomputed on demand instead of kept in a counter: a stored counter can drift
# out of sync with the claim list, and this one cannot.
scoreboard players set #used cl.tmp 0
data modify storage chunkloader:tmp iter set from storage chunkloader:data claims
execute if data storage chunkloader:tmp iter[0] run function chunkloader:internal/count_step
