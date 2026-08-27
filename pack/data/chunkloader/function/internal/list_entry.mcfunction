# Macro args: owner, dname, cx, cz
$execute if data storage chunkloader:tmp {ctx:{owner:$(owner)}} run scoreboard players add #idx cl.tmp 1
$execute if data storage chunkloader:tmp {ctx:{owner:$(owner)}} run tellraw @s [{"text":"  "},{"score":{"name":"#idx","objective":"cl.tmp"},"color":"gray"},{"text":". ","color":"gray"},{"text":"$(dname)","color":"white"},{"text":"  chunk X ","color":"gray"},{"text":"$(cx)","color":"yellow"},{"text":", Z ","color":"gray"},{"text":"$(cz)","color":"yellow"}]
