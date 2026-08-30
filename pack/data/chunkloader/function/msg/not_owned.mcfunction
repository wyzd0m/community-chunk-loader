tellraw @s [{"text":"[ChunkLoader] ","color":"aqua"},{"text":"You do not have a claim on this chunk.","color":"red"}]
tellraw @s [{"text":"  "},{"text":"[Show my chunks]","color":"gold","clickEvent":{"action":"run_command","value":"/trigger chunks set 1"},"hoverEvent":{"action":"show_text","contents":[{"text":"Free any claim from anywhere, without travelling to it","color":"gray"}]}}]
