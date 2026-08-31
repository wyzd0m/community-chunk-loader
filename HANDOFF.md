# Community Chunk Loader - Handoff

**Purpose:** source of truth for resuming this project in a fresh Claude Code/chat session.

**Project stage:** **v1.2.0 released and in live use.** Commands, restart persistence, and offline Create-farm operation confirmed on the live server; performance never benchmarked. See TEST_PLAN.md section 10. The datapack in
`pack/` is complete and passes `tools/verify.sh`. Nothing has been run inside
Minecraft yet. The next action is in-game testing, not more code.

## 1. Problem

Small Minecraft Create community on a PebbleHost NeoForge server currently has to AFK inside farm chunks for overnight production.

Server details:

- Minecraft 1.21.1
- NeoForge
- All of Create / Create-focused modpack
- 16 GB server
- ~20-30 total community members
- ~9-10 regular Create players have asked for chunk loading

Farms such as iron and andesite production supply stock for a player-run shop economy.

## 2. Agreed v1 behavior

- Each player gets **4 chunk-loading slots** (configurable live).
- Claims remain active even while the owner is offline.
- No visual markers or world-space UI.
- Command-based interaction only.
- Server/datapack only; no client install.
- Players can remove old claims and add new ones whenever they want.
- When a player is at 4/4, new claims are rejected until one is removed.
- A simple "list my chunks" command is included.
- If performance becomes a problem, lower the per-player limit first.
- Automatic unloading while the player is online/nearby is **not v1**.
- Overworld, Nether, and End are all claimable, each toggleable by an admin.
  Modded dimensions are refused.

## 3. Player UX (implemented)

```text
/trigger chunkadd set 1
/trigger chunkfree set 1
/trigger chunks set 1
```

Add/remove act on the player's **current chunk**.

## 4. Architecture decisions (settled)

Full reasoning is in `ARCHITECTURE.md`. The short version:

- Claims are one flat list in command storage `chunkloader:data claims`, each
  entry `{owner, dim, dname, cx, cz, bx, bz}`.
- **No refcount.** `execute if data ... claims[{dim,cx,cz}]` partial-matches any
  element, so the list itself answers "does anyone else hold this chunk?".
- **No stored slot counter.** Recomputed on demand from the list.
- Chunk coordinates come from an `align xyz` marker probe, because
  `data get Pos[0]` truncates toward zero and breaks on negative coordinates.
- `/forceload` is driven by function macros wrapped in `execute in $(dim)`.
- `#minecraft:load` re-asserts every forceload and re-grants trigger access.
- Pack format **48**, 1.21 **singular** `function/` directories.

### Known platform limits, accepted

- A datapack cannot resolve an offline username to a UUID, so
  `admin/clear_player` requires the player to be online. `admin/clear_here` and
  `admin/list_all` cover the offline case by location instead.
- `admin/list_all` prints owners as raw UUID int arrays; match them against the
  server's `usercache.json`.

### Load-bearing assumption still unverified in-game

Macro substitution of a UUID int array into an `if data` list filter — that
`$(owner)` expands to `[I;...]` cleanly. The whole ownership model rests on it.
**Test this first.** If it fails, the storage model in `ARCHITECTURE.md` §3-4
needs rework.

## 5. Repository layout

```text
pack/                       the datapack itself (zip its CONTENTS, not the folder)
  pack.mcmeta
  data/chunkloader/function/
    load, tick               entrypoints via #minecraft:load / #minecraft:tick
    player/join              grants trigger access
    trigger/{add,remove,list}
    util/{context,owner,get_chunk,count_owned,reset_*}
    internal/*               macros and list-walk recursion
    msg/*                    all player-facing chat
    admin/*
  data/minecraft/tags/function/{load,tick}.json
build.ps1                   packages pack/ into dist/*.zip
tools/verify.sh             structural checks; run before every commit
docs/{INSTALL,COMMANDS,ADMIN}.md
```

## 6. Success criteria

A successful v1 must prove:

- regular players can manage claims without OP;
- a representative Create farm runs with the owner offline;
- claims survive restart;
- the 4-chunk limit is enforced;
- removing/replacing claims works;
- duplicate shared claims behave safely;
- server performance remains acceptable;
- 2-3 real players test it and confirm it solves the AFK problem.

## 7. Next actions, in order

1. **Local disposable world.** Load the pack, run the smoke test in
   `docs/INSTALL.md`, then work through the functional and edge-case sections of
   `TEST_PLAN.md`. Verify the macro/UUID assumption in section 4 above first.
2. Fix whatever breaks. Record what broke and why in `CHANGELOG.md` — the
   failures are the interesting part of the write-up, not the successes.
3. **Live server, controlled pilot.** 2-3 Create players, real farms, the
   persistence and performance sections of `TEST_PLAN.md`.
4. Collect the pilot questionnaire in `TEST_PLAN.md` §8.
5. Tag `v1.2.0` and attach the built zip to a GitHub release.

## 8. Case-study goal

Do not optimize this project for technical complexity.

The useful story is:

**real player problem → gathered requirements → identified constraints → used AI to learn/build → human testing and verification → player feedback → measured result**

Track decisions and failures while they happen so the final write-up is accurate rather than reconstructed afterward.
