# Test Plan

## 1. Purpose

The datapack is only successful if it solves the community's actual farm problem without causing unacceptable server performance or management issues.

Testing therefore covers:

- command behavior;
- ownership and limits;
- persistence;
- Create farm behavior;
- server performance;
- real player feedback.

## 2. Test environments

### Local / disposable test world

Use first for command logic and destructive testing.

### Live server controlled rollout

Minecraft 1.21.1, NeoForge, 16 GB PebbleHost server with the real Create modpack.

Do not begin with every player using all four slots.

## 2.5 Pre-flight checks

Run these before anything else. Each one fails *silently* in Minecraft, so a
green result here saves hours of confused debugging later.

```bash
bash tools/verify.sh
```

Then, in a disposable world:

- [ ] `/datapack list` shows the pack as enabled.
- [ ] `/function chunkloader:admin/status` prints without error.
      (If this errors, the pack did not load - check pack format and that the
      function directories are singular `function/`, not `functions/`.)
- [ ] `/trigger chunkadd set 1` at a **negative** coordinate (e.g. X -5, Z -5)
      registers the correct chunk. This is the floor-vs-truncate trap; verify
      against F3's `Chunk:` line.
- [ ] `/data get storage chunkloader:data claims` shows an entry whose `owner`
      is an int array.
- [ ] **The load-bearing one:** claim a chunk, then `/trigger chunkadd set 1` again
      in the same chunk. It must say "already claimed" rather than adding a
      second entry. That proves macro substitution of the UUID int array into an
      `if data` filter works. If this fails, stop and revisit
      `ARCHITECTURE.md` sections 3-4 before testing anything else.
- [ ] No red error text appears in chat or console during any of the above.

## 3. Functional tests

### Add

- [ ] Non-OP player can run the add trigger.
- [ ] Current chunk is registered.
- [ ] Success message reports updated slot count.
- [ ] Same player cannot add the same chunk twice.
- [ ] Player can add chunks up to the configured limit.
- [ ] Fifth chunk is rejected when limit is 4.
- [ ] Failed add does not corrupt slot count.

### Remove

- [ ] Player can remove a chunk they own.
- [ ] Slot count decreases.
- [ ] Freed slot can be reused immediately.
- [ ] Player cannot remove a chunk they do not own.
- [ ] Removing the last owner causes the datapack-managed force-load to be removed.
- [ ] Removing one of multiple owners does not unload the chunk.

### List

- [ ] Empty list is readable.
- [ ] List correctly shows 1-4 claims.
- [ ] Coordinates are correct.
- [ ] Dimension is correct.
- [ ] Slot count is correct.

## 4. Persistence tests

### Logout

1. Register a chunk containing a Create farm.
2. Leave the chunk.
3. Log the owner out.
4. Leave the server with no player near the farm.
5. Wait long enough to observe meaningful production.
6. Confirm the farm continued to operate.

### Server restart

1. Register at least two chunks.
2. Record coordinates and inventory state.
3. Fully stop the server.
4. Start the server.
5. Confirm player claim records still exist.
6. Confirm the underlying chunks remain or become force-loaded correctly.
7. Confirm Create machines resume/continue behavior.

### Datapack reload

- [ ] `/reload` does not duplicate records.
- [ ] `/reload` does not inflate ownership counts.
- [ ] `/reload` does not lose claims.

## 5. Create-specific validation

Test the farms players actually care about, not only a synthetic redstone machine.

Initial candidates:

- iron production;
- andesite production;
- another representative Create processing line.

For each test:

1. Record input/output inventory counts.
2. Leave the loaded area.
3. Ensure no player is nearby.
4. Wait a fixed period.
5. Return.
6. Compare production.

If a farm does not work while force-loaded, determine whether the issue is:

- datapack failure;
- chunk not actually loaded;
- Create mechanic requiring some other condition;
- another mod or server configuration.

Do not declare the project successful until at least one real requested farm works in the intended offline condition.

## 6. Performance tests

### Baseline

Before rollout, record during a normal active period:

- TPS/MSPT if available through the server's existing tooling;
- memory usage;
- player-reported lag;
- number of AFK farm players normally online.

### Controlled load

Test incrementally:

1. 1 player × 1 loaded chunk.
2. 1 player × 4 loaded chunks.
3. 3 players with realistic farms.
4. 5+ players if previous stages remain healthy.

Avoid jumping directly to the theoretical maximum.

### Failure response

If performance becomes noticeably worse:

1. confirm whether loaded farms are actually the cause;
2. reduce per-player limit;
3. retest;
4. only then consider architectural optimization.

## 7. Abuse / edge cases

- [ ] Player spams add trigger.
- [ ] Player spams remove trigger.
- [ ] Player alternates add/remove rapidly.
- [ ] Two players claim the same chunk.
- [ ] Player changes dimension before/after commands.
- [ ] Player logs out immediately after adding.
- [ ] Server restarts with claims belonging only to offline players.
- [ ] Admin clears all claims.
- [ ] New claims are disabled while existing claims remain active.
- [ ] Invalid data does not create an uncontrolled force-load.

## 8. Community pilot

Choose 2-3 regular Create players first.

Ask each tester:

1. What farm are you using this for?
2. How many chunks did you actually need?
3. Did the farm continue working while you were offline?
4. Was the command workflow understandable without help?
5. Did anything behave differently than expected?
6. Did this remove the need to AFK overnight?
7. What would you change?

Save feedback privately or in a sanitized `docs/feedback.md` if testers consent.

## 9. Project outcome metrics

Useful final measurements:

- number of testers;
- number of active chunk claims;
- number of farms successfully running offline;
- whether players stopped needing to AFK for those farms;
- whether the 4-chunk limit was sufficient;
- server performance before/after;
- bugs found during testing;
- changes made because of player feedback.

These are more valuable than code size for the final case study.

---

## 10. Results - v1.2.0, 2026-08-31

Recorded against the live NeoForge / Create server, not a disposable world.

### Confirmed working

- **Commands and menu.** Claim, free, and list all behave as specified. The
  clickable menu, the `[free]` buttons, and the hover tooltips work for non-OP
  players. Slot accounting and the 4-chunk limit hold.
- **Persistence across restart.** Claims survived a full server stop and start,
  and the chunks came back force-loaded.
- **Offline farm operation.** A Create farm kept processing with no player
  nearby. This is the problem the project set out to solve, and it is solved.
- **Multiple players.** Other members of the server ran the commands
  successfully on the live server.

### Not formally measured

These are not known failures - they were simply never benchmarked, and the
project shipped without them:

- **Performance before/after.** No TPS or MSPT baseline was captured, so there
  is no number to compare against as claim count grows. Section 6 was not run.
  If lag reports appear, lower the per-player limit first
  (`/function chunkloader:admin/set_limit {n:2}`) and re-check.
- **Shared-chunk ownership.** Two players claiming the same chunk, and the
  chunk staying loaded until the last owner releases it, was not exercised with
  two real accounts. The logic is covered by the claim-list-as-refcount design
  but has not been observed end to end.
- **Admin recovery paths.** `clear_all`, `clear_here`, `clear_player`, and
  `panic` were not run against real claim data.

### Worth watching during normal use

- Claim count growth. `/function chunkloader:admin/status` reports the total.
- Whether four slots per player turns out to be the right number.
- Whether anyone still feels the need to AFK overnight.
