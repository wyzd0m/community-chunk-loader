# Re-assert /forceload for every stored claim.
# Runs automatically from #minecraft:load, and is safe to run by hand.
# Silent by design: it executes at server level on load, where @s does not exist.
data modify storage chunkloader:tmp iter set from storage chunkloader:data claims
execute if data storage chunkloader:tmp iter[0] run function chunkloader:internal/reconcile_step
