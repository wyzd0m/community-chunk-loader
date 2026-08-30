# Macro args: n, k, dname, cx, cz, bx, bz
# 1.21.1 text-component spelling: clickEvent/value and hoverEvent/contents.
# These were renamed to click_event/hover_event in 1.21.5 - do not "modernise"
# them here without also bumping pack_format.
$tellraw @s [{"text":"  "},{"text":"$(n)","color":"gray"},{"text":". ","color":"gray"},{"text":"$(dname)","color":"white"},{"text":"  chunk X ","color":"gray"},{"text":"$(cx)","color":"yellow"},{"text":", Z ","color":"gray"},{"text":"$(cz)","color":"yellow"},{"text":"   "},{"text":"[free]","color":"red","clickEvent":{"action":"run_command","value":"/trigger cl_slot set $(k)"},"hoverEvent":{"action":"show_text","contents":[{"text":"Release this chunk","color":"red"},{"text":"\nIt stops staying loaded while you are offline.","color":"gray"},{"text":"\nCorner block: $(bx), $(bz)","color":"dark_gray"}]}}]
