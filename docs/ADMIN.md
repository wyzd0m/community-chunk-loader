# Admin guide

All admin entry points are `/function` calls and need permission level 2 (op).
Unless noted, run them **as a player** - several print their results to `@s`.

## Inspect

```text
/function chunkloader:admin/status
```

Total claims, per-player limit, whether new claims are accepted, and which
dimensions are open.

```text
/function chunkloader:admin/list_all
```

Every claim on the server: dimension, chunk coordinates, and the owner's UUID.

> The owner prints as a raw UUID int array such as `[I;-1234,5678,...]`. A
> datapack has no way to turn a UUID into a username, so cross-reference it
> against the server's `usercache.json` when you need to identify someone.

## Tuning

```text
/function chunkloader:admin/set_limit {n:4}
```

Changes the per-player limit. **This is the first lever to pull if the server
starts struggling.** Lowering it never deletes existing claims - players over the
new limit simply cannot add more until they drop back under it.

```text
/function chunkloader:admin/set_dimensions {overworld:1,nether:1,end:0}
```

`1` allows new claims in that dimension, `0` blocks them. Blocking a dimension
does not unload anything already claimed there, and owners can still remove those
claims.

## Pausing

```text
/function chunkloader:admin/disable_new_claims
/function chunkloader:admin/enable_new_claims
```

While disabled, `chunkadd` refuses with an explanation. Existing claims stay loaded
and `chunkfree` keeps working, so players can always shrink their footprint.

## Cleanup

```text
/function chunkloader:admin/clear_here
```

Stand in a chunk and run this to strip **every** claim on it regardless of owner,
then unload it. This is the tool for offline players: you generally know where
the problem farm is even if you cannot resolve the owner.

```text
/execute as <PlayerName> run function chunkloader:admin/clear_player
```

Removes every claim belonging to that player, respecting shared chunks. **The
player must be online** - a datapack cannot resolve an offline username to a
UUID. For offline players, use `clear_here` or `list_all` plus `clear_here`.

```text
/function chunkloader:admin/clear_all
```

Releases exactly the chunks this datapack force-loaded and empties the claim
list. Forceloads created by anything else are left alone. This is the correct
uninstall step.

## Recovery

```text
/function chunkloader:admin/reconcile
```

Re-issues `/forceload add` for every stored claim. Runs automatically on every
server start and `/reload`, so you rarely need it by hand - but it is the fix if
someone ran `/forceload remove all` or a `chunks.dat` was lost. It prints nothing
by design, because it also runs at server level where `@s` does not exist. Follow
it with `admin/status` to confirm.

```text
/function chunkloader:admin/panic
```

**Last resort.** Runs `/forceload remove all` in the Overworld, Nether, and End,
wipes the claim list, and disables new claims. This also destroys forceloads the
datapack did not create - other datapacks, other admins, anything. Prefer
`clear_all` unless the state is genuinely broken.

## Configuration reference

Configuration lives in the `cl.cfg` scoreboard, so it persists across restarts
and `/reload` and is seeded only when unset. You can read or set it directly:

| Fake player        | Default | Meaning                          |
|--------------------|---------|----------------------------------|
| `#max_chunks`      | `4`     | Claim slots per player           |
| `#claims_enabled`  | `1`     | Accept new claims                |
| `#dim_overworld`   | `1`     | Allow claims in the Overworld    |
| `#dim_nether`      | `1`     | Allow claims in the Nether       |
| `#dim_end`         | `1`     | Allow claims in the End          |

```text
/scoreboard players get #max_chunks cl.cfg
/scoreboard players set #max_chunks cl.cfg 2
```

Prefer the admin functions - they exist so you do not have to remember these.

## Where the data lives

Claims are stored in command storage under `chunkloader:data`, which the server
writes to `<world>/data/command_storage_chunkloader.dat`. To inspect it live:

```text
/data get storage chunkloader:data claims
```

Back that file up before any risky cleanup.

## If the server starts lagging

Follow this order, and re-measure between steps:

1. Confirm the loaded farms are actually the cause. Compare TPS/MSPT with the
   claims cleared versus restored, not against a vague memory of "before".
2. `set_limit` to a smaller number.
3. `disable_new_claims` to stop growth while you investigate.
4. `clear_here` on the specific offenders.
5. Only then consider whether the design needs changing.

Lowering the limit is deliberately the first response. Adding complexity to a
system that is already too expensive rarely makes it cheaper.

## Upgrading from an earlier build

Drop the new zip over the old one and restart (or `/reload`). Claims are
untouched - they live in command storage, not in the pack.

Objectives are created once and recorded in `chunkloader:data setup_version`, so
a world that already installed the pack will not re-run the initial setup. New
objectives arrive through migrations instead, which run automatically on load.

To confirm a migration applied:

```text
/data get storage chunkloader:data setup_version
```

| Version | Introduced |
| --- | --- |
| 1 | initial release |
| 2 | `chunkslot` and `cl.gen`, backing the clickable menu |
| 3 | triggers renamed to `chunks` / `chunkadd` / `chunkfree` / `chunkslot` |

If that returns 1 after a reload, the migration did not run. Check the server
console for errors from `chunkloader:load`.

### Repairing missing objectives by hand

If an objective was deleted manually, recreate just that one rather than
re-running setup:

```text
/scoreboard objectives add chunkslot trigger
```

Do not clear `setup_version` to force setup to re-run - it would throw on every
objective that still exists, and the errors would fill your console on each
`/reload`.
