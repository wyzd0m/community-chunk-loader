# Installation

## Requirements

- Minecraft Java Edition **1.21.1** (pack format 48)
- Any server that loads vanilla datapacks - vanilla, Paper, Fabric, or **NeoForge**
- No client-side installation. Players install nothing.

## Install

1. Download `community-chunk-loader-vX.Y.Z.zip` from the Releases page, or build
   it yourself with `.\build.ps1`.
2. Upload it to your world's datapack folder:

   ```text
   <server root>/<world name>/datapacks/community-chunk-loader-v1.0.0.zip
   ```

   On PebbleHost this is usually `world/datapacks/`. If your server splits
   dimensions into `world`, `world_nether`, and `world_the_end`, the datapack
   still goes in the **main** `world/datapacks/` folder only.

3. Restart the server. A restart is cleaner than `/reload` for a first install.

## Verify

Run these as an operator:

```text
/datapack list
```

`community-chunk-loader` (or the zip name) should appear under *available* and
*enabled*.

Then:

```text
/function chunkloader:admin/status
```

You should see the claim total, the per-player limit, and which dimensions are
open. If that command errors, the datapack did not load.

## First smoke test

1. Stand somewhere harmless.
2. `/trigger cl_add set 1` - expect a green confirmation and `1 / 4 slots`.
3. `/forceload query` - the chunk you are standing in should be listed.
4. `/trigger cl_list set 1` - your claim should appear.
5. `/trigger cl_remove set 1` - expect a green confirmation and `0 / 4 slots`.
6. `/forceload query` - the chunk should be gone.

## Uninstall

```text
/function chunkloader:admin/clear_all
```

That releases every chunk the datapack force-loaded and empties the claim list.
Only then remove the zip and restart. Deleting the zip **without** clearing first
leaves the chunks force-loaded with nothing left to manage them - you would have
to clean them up manually with `/forceload remove`.

## Notes for NeoForge / Create servers

- `/forceload` chunks are fully ticked, which is what Create kinetics and
  processing need. This is not the same as a "lazy" chunk.
- Modded dimensions are not claimable. The datapack recognises the three vanilla
  dimensions only; anywhere else, `cl_add` refuses with a clear message rather
  than storing something it cannot reload later.
