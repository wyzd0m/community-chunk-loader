# Architecture

> Status: **implemented**. This document describes what was built and why. The
> open questions the original plan listed are resolved in section 12, with the
> reasoning kept rather than deleted.

## 1. Design target

A lightweight server-only datapack for Minecraft Java 1.21.1 that manages a
bounded set of persistent `/forceload` claims on behalf of ordinary players,
without per-tick world scanning.

## 2. Player-facing interface

Datapacks cannot register new slash commands, so the interface is three
scoreboard triggers:

```text
/trigger chunkadd set 1
/trigger chunkfree set 1
/trigger chunks set 1
```

This is also what makes the feature work without OP: `/forceload` needs
permission level 2, but functions execute at level 2 regardless of who triggered
them. The player never touches `/forceload` directly.

`tick.mcfunction` is deliberately minimal:

```text
execute as @a unless score @s cl.init matches 1 run function chunkloader:player/join
execute as @a[scores={chunkadd=1..}] at @s run function chunkloader:trigger/add
execute as @a[scores={chunkfree=1..}] at @s run function chunkloader:trigger/remove
execute as @a[scores={chunks=1..}] run function chunkloader:trigger/list
```

plus three lines that swallow negative trigger values, because a player can type
`/trigger chunkadd set -5`. Each handler re-arms its own trigger as its first
action, so an error path can never leave a player locked out.

## 3. Persistent data model

One flat list in command storage:

```text
storage chunkloader:data claims [
  {owner:[I;...], dim:"minecraft:overworld", dname:"Overworld", cx:12, cz:-4, bx:192, bz:-64},
  ...
]
```

| Field | Why it exists |
|---|---|
| `owner` | Player UUID int array. Stable across username changes. |
| `dim` | Resource location, used by `execute in $(dim)`. |
| `dname` | Friendly name, used only for chat output. |
| `cx` / `cz` | Chunk coordinates. The identity of a claim. |
| `bx` / `bz` | Chunk-origin block coordinates, since `/forceload` takes block coords. |

`bx`/`bz` are stored rather than derived because macros cannot do arithmetic, and
they are canonicalised to the chunk origin (`cx * 16`) so that two players
claiming the same chunk from different positions store the same value.

Command storage is written to `<world>/data/command_storage_chunkloader.dat` and
survives `/reload`, logout, and full restarts.

## 4. Shared ownership without a reference count

The original plan called for a global refcount. It turned out to be unnecessary.

NBT list matching in `execute if data` is a *partial* match against **any**
element, so the claim list answers the refcount question directly:

```text
execute if data storage chunkloader:data claims[{dim:"...",cx:12,cz:-4}]
```

- **Add:** if that query finds nothing, call `/forceload add`. Then append.
- **Remove:** delete the owner's entry, then run the same query. If it now finds
  nothing, call `/forceload remove`.

Two players claiming the same chunk works, one removing does not unload the
other, and there is no counter that can drift out of sync with reality. A whole
category of bug is designed away rather than handled.

The per-player slot count is treated the same way: it is **recomputed on demand**
from the claim list rather than kept in a persistent counter. Adds and removes
are rare and human-triggered, so an O(n) walk costs nothing, and the count is
structurally incapable of being wrong.

## 5. Resolving the player's chunk

There is no scoreboard criterion for a player's chunk, and the obvious approach
is subtly broken:

```text
execute store result score #x cl.tmp run data get entity @s Pos[0] 1
```

`data get` truncates toward zero. A player at `x = -0.5` reports `0`, but the
correct floor is `-1`. Every claim made just west or north of the origin would
target the wrong chunk.

`util/get_chunk.mcfunction` avoids it:

1. `execute at @s align xyz run summon marker ~ ~ ~` — `align` floors the
   execution position correctly, including negatives.
2. Read the marker's `Pos`, which is now exactly integral, so truncation is a
   no-op.
3. `kill` the probe (scoped by `distance=..3`, never a bare global selector).
4. `/= 16` — scoreboard division is floor division, so negative chunk
   coordinates come out right too.

The probe exists for a few commands inside a single function call, only when a
player runs a command. `load.mcfunction` kills any probe orphaned by a crash.

## 6. Executing stored coordinates

Function macros, driven from storage:

```text
$execute unless data storage chunkloader:data claims[{dim:"$(dim)",cx:$(cx),cz:$(cz)}] in $(dim) run forceload add $(bx) $(bz)
```

The `in $(dim)` wrapper is mandatory, not decorative: `/forceload` acts on the
*execution* dimension, so without it every claim would be applied to whichever
dimension the command happened to run in.

Macros stay dumb on purpose. They perform an action or set a flag score; all
branching lives in ordinary functions where it is readable.

## 7. Dimensions

The three vanilla dimensions are recognised via `execute if dimension`, each with
its own config toggle. Anything else — a modded dimension — leaves `dim` as
`"unsupported"` and the claim is refused.

Refusing is the deliberate choice. A stored claim in a dimension the pack cannot
name is a claim it cannot restore after a restart, and a silent no-op later is
worse than a clear rejection now.

Dimension *identity* is resolved separately from the config *gate*, so a player
can still remove a claim in a dimension an admin has since closed. Otherwise
disabling a dimension would trap claims there permanently.

## 8. Restart and reload behaviour

Vanilla persists `/forceload` state on its own, so claims would survive a restart
even with no reconciliation. The pack reconciles anyway: `#minecraft:load` walks
the claim list and re-issues `/forceload add` for every entry.

It is idempotent and costs one pass over a list of at most a few hundred entries,
once per start. In exchange it recovers from a manual `/forceload remove all`, a
lost `chunks.dat`, or a world restored from a partial backup. Cheap insurance
against a class of failure that would otherwise be silent.

`load.mcfunction` also runs `scoreboard players reset * cl.init`, which pushes
every online player back through `player/join` and re-grants trigger access. This
makes `/reload` a repair action rather than something that can strand players.

## 9. Admin surface

```text
/function chunkloader:admin/status
/function chunkloader:admin/list_all
/function chunkloader:admin/reconcile
/function chunkloader:admin/set_limit {n:4}
/function chunkloader:admin/set_dimensions {overworld:1,nether:1,end:1}
/function chunkloader:admin/enable_new_claims
/function chunkloader:admin/disable_new_claims
/function chunkloader:admin/clear_here
/execute as <Player> run function chunkloader:admin/clear_player
/function chunkloader:admin/clear_all
/function chunkloader:admin/panic
```

See [`docs/ADMIN.md`](docs/ADMIN.md). Two behaviours worth stating here:

- `clear_all` unloads **exactly** the chunks this pack loaded. `panic` runs
  `forceload remove all` and will destroy other people's forceloads too; it is
  documented as a last resort for a broken state.
- `reconcile` is silent because it also runs at server level during load, where
  `@s` does not exist. A `tellraw @s` there would error into the console on every
  start.

## 10. Configuration

Config lives in the `cl.cfg` scoreboard as fake players, seeded only when unset:

```text
execute unless score #max_chunks cl.cfg matches -2147483648.. run scoreboard players set #max_chunks cl.cfg 4
```

Scoreboards persist, so an admin's change to the limit survives restarts and is
not clobbered on the next `/reload`. Editing a file and re-uploading the pack was
rejected as the config mechanism precisely because the most likely moment to need
a lower limit is while the server is struggling.

## 11. Performance design

Per tick: four score-filtered `@a` selectors. Nothing else.

Everything expensive is event-driven — a player typing a command, or a server
start. There is no ticking entity, no chunk scan, and no repeated
`/forceload add`.

The list walks are recursive over a copy of the claim list. At the design target
(~30 players x 4 slots = ~120 entries) this is far below any command-chain limit,
and it only runs when someone types `chunks` or `chunkadd`.

## 12. Resolved design questions

The original plan listed seven questions to answer before coding. For the record:

1. **Persistent UUID to claim-list storage.** Command storage, one flat list,
   `owner` as the UUID int array. Chosen over per-player compound keys because a
   flat list supports `if data` partial matching and `data remove` with a filter,
   which is what makes sections 4 and 6 work.
2. **Global refcount representation.** Not needed — see section 4.
3. **Executing stored coordinates in `/forceload`.** Function macros plus
   `execute in $(dim)`, with block coordinates stored because macros cannot
   multiply. See section 6.
4. **Dimension handling.** Resource location string, three vanilla dimensions,
   anything else refused. See section 7.
5. **Reconciliation after restart or `/reload`.** Unconditional re-add from
   `#minecraft:load`. See section 8.
6. **Offline-player admin cleanup.** Partially solved, and the limit is real: a
   datapack cannot resolve an offline username to a UUID, so `clear_player` needs
   the player online. `clear_here` and `list_all` cover the offline case by
   location instead of by identity. This is a genuine constraint of the platform,
   not an oversight.
7. **Whether vanilla `/forceload` persistence is enough.** It is, but the pack
   reconciles anyway. See section 8.

### Verified against the runtime, not assumed

Two things in this design fail *silently* if wrong, so they are called out:

- **Pack format 48** and the **1.21 singular directory layout**
  (`data/<ns>/function/`, `data/minecraft/tags/function/`). A pack copied from a
  1.20 tutorial with plural `functions/` loads without complaint and simply never
  runs. `tools/verify.sh` checks both.
- **Macro substitution of a UUID int array** into an `if data` list filter. This
  is the load-bearing assumption of the whole ownership model. It is the first
  thing to confirm in a disposable world — if `$(owner)` does not expand to
  `[I;...]` cleanly, sections 4 and 12.1 need revisiting.

## 13. Deliberately out of v1

Automatic suspension when the owner is nearby, clickable chat controls, a `move`
command, a physical chunk-loader block, permission tiers, per-dimension limits, a
server-wide cap, telemetry, claim expiry, and an admin UI.

None of these block v1, and several would be actively wrong to add before real
usage data exists.
