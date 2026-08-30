# Only offer the claim button when it would actually succeed: a button that
# fails on click is worse than no button.
execute unless score #claims_enabled cl.cfg matches 1 run return run function chunkloader:msg/list_disabled_note
execute if score #used cl.tmp >= #max_chunks cl.cfg run return run function chunkloader:msg/list_full_note
function chunkloader:msg/list_add_button
