# Minimal context: just the executing player's UUID.
data modify storage chunkloader:tmp ctx set value {}
data modify storage chunkloader:tmp ctx.owner set from entity @s UUID
