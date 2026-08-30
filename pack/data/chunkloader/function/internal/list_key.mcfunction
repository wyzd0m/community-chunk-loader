# Stamps the current row with its display number (n) and its click key (k).
#
# k = generation * 100 + row. The generation is bumped every time the player
# opens the menu, so a button from an older printout decodes to a generation
# that no longer matches and is refused. Without this, freeing a claim shifts
# every row number below it, and a second click on the same stale menu would
# release a DIFFERENT chunk than the one the player clicked - silently
# unloading someone's farm.
#
# The *100 packing caps the menu at 99 rows. The per-player limit is 4.
scoreboard players operation #enc cl.tmp = #gen cl.tmp
scoreboard players operation #enc cl.tmp *= #100 cl.tmp
scoreboard players operation #enc cl.tmp += #idx cl.tmp

execute store result storage chunkloader:tmp entry.n int 1 run scoreboard players get #idx cl.tmp
execute store result storage chunkloader:tmp entry.k int 1 run scoreboard players get #enc cl.tmp
