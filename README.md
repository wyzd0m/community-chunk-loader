# Community Chunk Loader

[![verify](https://github.com/wyzd0m/community-chunk-loader/actions/workflows/verify.yml/badge.svg)](https://github.com/wyzd0m/community-chunk-loader/actions/workflows/verify.yml)

A server-only Minecraft **1.21.1** datapack that gives every player a small,
bounded number of chunks that stay loaded while they are offline.

Built for a ~25-member NeoForge **Create** server where players were leaving
accounts AFK overnight so their farms would keep producing for the server
economy. This replaces that workaround with something the server owner can
measure and cap.

```text
/trigger cl_add set 1       claim the chunk you are standing in
/trigger cl_remove set 1    release your claim on this chunk
/trigger cl_list set 1      see your claims and slot usage
```

- **No client mods.** Players install nothing.
- **No OP required.** Ordinary players manage their own chunks.
- **Survives logout, `/reload`, and full server restarts.**
- **Bounded.** 4 chunks per player by default, changeable live with one command.
- **Shared-chunk safe.** Two players can claim the same chunk; it only unloads
  when the last owner lets go.
- **Reversible.** One admin command releases everything the pack created.

## Status

**v1.0.0 is written and structurally verified, but has not yet completed the
live-server pilot.** The functional, persistence, Create-farm, and performance
tests in [`TEST_PLAN.md`](TEST_PLAN.md) are the gate for tagging a release.
Treat this as ready-to-test, not battle-tested.

## Install

Drop the zip into `<world>/datapacks/` and restart the server. Full steps,
verification, and uninstall are in [`docs/INSTALL.md`](docs/INSTALL.md).

```powershell
.\build.ps1
```

Builds `dist/community-chunk-loader-v1.0.0.zip` from `pack/`.

## Documentation

| Document | What it covers |
|---|---|
| [`docs/INSTALL.md`](docs/INSTALL.md) | Installing, verifying, uninstalling |
| [`docs/COMMANDS.md`](docs/COMMANDS.md) | The three player commands |
| [`docs/ADMIN.md`](docs/ADMIN.md) | Admin functions, tuning, recovery |
| [`ARCHITECTURE.md`](ARCHITECTURE.md) | How it works and why it is built this way |
| [`REQUIREMENTS.md`](REQUIREMENTS.md) | User stories, rules, definition of done |
| [`TEST_PLAN.md`](TEST_PLAN.md) | What has to pass before this is trusted |
| [`HANDOFF.md`](HANDOFF.md) | Compact context for picking the project back up |

## How it works, briefly

Each claim is one entry in command storage:

```text
{owner:[I;...], dim:"minecraft:overworld", dname:"Overworld", cx:12, cz:-4, bx:192, bz:-64}
```

The claim list doubles as the reference count. Before force-loading, the pack
asks "does any entry already exist for this chunk?" - if not, it calls
`/forceload add`. On removal it asks the same question after deleting the owner's
entry, and only calls `/forceload remove` when the answer is no. There is no
separate counter to drift out of sync.

Per-tick cost is four score-filtered `@a` selectors and nothing else. Every real
operation happens only when a player types a command.

## Compatibility

- Minecraft Java **1.21.1** (pack format 48).
- Works on vanilla, Paper, Fabric, and NeoForge - it uses only vanilla commands.
- Claims are limited to the Overworld, Nether, and End. Modded dimensions are
  refused rather than stored in a form the pack could not restore on restart.

## Contributing

`bash tools/verify.sh` runs the structural checks - dangling function
references, macro lines missing their leading `$`, macros called without
arguments, JSON validity, CRLF line endings, and the 1.21 singular-directory
layout. It catches most of what would otherwise only appear as red text in-game,
or as nothing at all.

CI runs the same script on every push and pull request, and attaches a built zip
to each run so testers can grab an installable pack without a local PowerShell
build.

Run the script locally before opening a PR - it is the same command, so a green
local run means a green CI run.

## License

MIT - see [`LICENSE`](LICENSE).
