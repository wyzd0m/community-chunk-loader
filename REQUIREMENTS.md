# Requirements

## 1. Problem statement

Players on the Create server rely on automated farms for materials used in the server's shop economy. When no player is present in a farm's chunk, the farm stops processing. The current workaround is to leave an account AFK overnight.

Several regular players have asked for a way to keep a limited number of farm chunks active while offline.

## 2. Primary goal

Provide a server-only datapack that lets each player choose up to **4 chunks** that remain force-loaded even when that player is offline.

## 3. Non-goals for v1

The first version will **not** include:

- physical chunk-loader blocks or entities as a user-facing mechanic;
- particles, holograms, borders, or other world-space visualization;
- a GUI;
- automatic chunk loading based on farm detection;
- automatic unloading when the owner comes online or enters the area;
- economy costs, permissions tiers, or paid upgrades;
- more than one server-wide default limit;
- complex analytics or dashboards.

These can be reconsidered only after v1 is proven useful and stable.

## 4. User stories

### Add a chunk

As a player, I want to stand in a chunk and register it as one of my loaded chunks so my farm can continue operating while I am offline.

Acceptance rules:

- The player can do this without OP permissions.
- The current chunk is used automatically.
- The same player cannot add the same chunk twice.
- The add fails cleanly if the player already owns 4 loaded chunks.
- The player receives a clear success or error message.

### Remove a chunk

As a player, I want to remove one of my loaded chunks so I can use that slot somewhere else.

Acceptance rules:

- A player can remove a chunk they own.
- Removing the chunk frees one of their 4 slots.
- Removing a chunk must not unload it if another player also owns a loading claim on the same chunk.
- Attempting to remove a chunk the player does not own must fail cleanly.

### List my chunks

As a player, I want to see which chunks I currently own so I can manage my allocation.

The list should show, at minimum:

- dimension;
- chunk X;
- chunk Z;
- number of slots used out of 4.

No world-space visualization is required.

### Persistence

As a player, I expect my registered chunks to still be loaded after:

- I log out;
- everyone logs out;
- the server restarts.

### Admin recovery

As an administrator, I need a way to:

- inspect total registered chunks;
- clear a specific player's entries;
- clear all datapack-managed force-loaded chunks;
- disable new registrations if troubleshooting performance;
- change the per-player limit from the default of 4.

The exact admin interface can use `/function` commands in v1.

## 5. Functional rules

- Default allocation: **4 chunks per player**.
- Registered chunks remain force-loaded while the owner is offline.
- Players can remove old chunks and add replacements at any time.
- No visible block/entity is required in the world.
- Player-facing interaction should use `/trigger` commands.
- New trigger access should be re-enabled automatically after each use.
- Data must survive player logout and server restart.
- Duplicate claims by different players must not break unloading behavior.
- The datapack must distinguish dimensions when storing a chunk.
- v1 should not silently delete player claims.

## 6. Performance / safety requirements

The feature exists partly to reduce the need for overnight AFK accounts, but force-loading still has a server cost.

Therefore:

- the per-player limit must be configurable;
- the datapack must include a global emergency shutdown/clear path;
- no implementation should repeatedly add/remove the same force-load every tick;
- the datapack should do as little per-tick work as practical;
- rollout should begin with a small group before server-wide use;
- server performance should be compared before and after enabling representative Create farms;
- if performance becomes unacceptable, the first response is to lower the per-player limit rather than add complexity.

## 7. Decisions resolved during implementation

These were deliberately left open in planning. All are now settled; the reasoning
is in `ARCHITECTURE.md` section 12.

1. **Dimension policy** — Overworld, Nether, and End are all claimable, each with
   its own admin toggle. Modded dimensions are refused, because a claim the pack
   cannot name is a claim it cannot restore after a restart.

2. **Duplicate ownership** — allowed, and handled without a reference count. The
   claim list itself answers "does anyone else hold this chunk?" via NBT list
   partial matching, so one owner removing never unloads another's farm and there
   is no counter that can drift.

3. **Offline identity storage** — the player's UUID int array, stored on each
   claim. Stable across username changes. The accepted cost: a datapack cannot
   resolve an offline username back to a UUID, so per-player admin cleanup needs
   the player online. Location-based cleanup (`admin/clear_here`) covers the rest.

4. **Coordinate storage** — command storage, one flat list of claim compounds.
   Chosen over marker entities (no per-chunk ticking cost) and over per-player
   compound keys (a flat list supports the filtered `if data` and `data remove`
   that make decision 2 work). Chunk coordinates are the claim's identity;
   chunk-origin block coordinates are stored alongside because `/forceload` takes
   block coordinates and macros cannot multiply.

5. **Command UX** — the working names were kept as-is:
   - `/trigger cl_add set 1`
   - `/trigger cl_remove set 1`
   - `/trigger cl_list set 1`

## 8. Definition of done

v1 is complete only when all of the following are true:

- [ ] A non-OP player can add their current chunk.
- [ ] A player cannot exceed the configured 4-chunk limit.
- [ ] A player can remove a chunk and immediately reuse the slot.
- [ ] A player can list their registered chunks.
- [ ] Claims survive logout.
- [ ] Claims survive a full server restart.
- [ ] A representative Create farm continues processing with no player nearby.
- [ ] A representative Create farm continues processing while the owner is offline.
- [ ] Duplicate ownership does not cause incorrect unloading.
- [ ] Invalid/duplicate commands fail with useful chat messages.
- [ ] Admins can clear claims and recover from a bad state.
- [ ] At least 2-3 community members test the system.
- [ ] Player feedback confirms it solves the original AFK problem.
- [ ] Server performance remains acceptable during a realistic overnight-style test.
