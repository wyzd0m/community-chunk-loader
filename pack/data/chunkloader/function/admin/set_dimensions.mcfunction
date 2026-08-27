# /function chunkloader:admin/set_dimensions {overworld:1,nether:1,end:1}
# Blocking a dimension only blocks NEW claims there; existing ones stay loaded
# and remain removable by their owners.
$scoreboard players set #dim_overworld cl.cfg $(overworld)
$scoreboard players set #dim_nether cl.cfg $(nether)
$scoreboard players set #dim_end cl.cfg $(end)
function chunkloader:admin/status
