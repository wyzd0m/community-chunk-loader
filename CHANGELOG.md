# Changelog

All notable changes to this project are documented here.

## [1.0.0] - Unreleased

First working version. Not yet validated on the live server; see `TEST_PLAN.md`
for what still has to pass before this is tagged.

### Added

- `/trigger cl_add set 1` - claim the chunk you are standing in.
- `/trigger cl_remove set 1` - release your claim on the chunk you are standing in.
- `/trigger cl_list set 1` - list your claims and slot usage.
- Shared chunk ownership: two players can claim the same chunk, and it only
  unloads when the last owner releases it.
- Persistence across logout, `/reload`, and full server restart.
- Automatic reconciliation of `/forceload` state on every load.
- Overworld, Nether, and End support, each individually toggleable.
- Admin functions: `status`, `list_all`, `reconcile`, `clear_here`,
  `clear_player`, `clear_all`, `panic`, `set_limit`, `set_dimensions`,
  `enable_new_claims`, `disable_new_claims`.
- `build.ps1` packaging script and `tools/verify.sh` structural checks.

### Tooling

- GitHub Actions workflow running `tools/verify.sh` on every push and pull
  request, attaching a built zip to each run.

### Fixed (pre-release, in tooling)

- `tools/verify.sh` reported failures but exited 0. Its check loops ran in
  subshells via pipes, so the failure flag never reached the parent shell - CI
  would have passed on a broken pack. Rewritten to read from process
  substitution.
- The CRLF check used `grep -rl`, which under Git Bash flags every file
  regardless of content. Replaced with a per-file check.
- `build.ps1` wrote `pack.mcmeta` with `Set-Content`, emitting CRLF against the
  repo's LF policy.

## v1.1.0

### Added

- **Clickable menu.** `/trigger cl_list set 1` now prints each claim with a
  `[free]` button and a `[+ Claim the chunk I am standing in]` button below.
  Players need to remember one command instead of three.
- **Release a claim from anywhere.** Previously a player had to travel to a
  chunk to give up its slot. `[free]` works from any distance, via a new
  click-only `cl_slot` trigger.
- Buttons are only drawn when clicking them would succeed: the claim button is
  replaced by an explanation when the player is at their limit or an admin has
  paused new claims.
- `setup_version` storage value plus a migration path, so servers that already
  installed the pack pick up objectives added in later releases.

### Fixed

- Freeing a claim renumbers the rows below it, so a second click on the same
  printed menu would have released a different chunk than the one clicked -
  silently unloading a farm. Buttons now carry the menu generation alongside the
  row number and refuse a stale click, reprinting the current list instead.
- `tools/verify.sh` now parses every `tellraw` payload, macro placeholders
  included. The clickable rows are hand-written JSON and are the easiest thing
  here to break unnoticed.

## v1.2.0 - 2026-08-31

### Changed

- **Player triggers renamed** so the menu is the thing worth remembering:

  | Before | Now |
  | --- | --- |
  | `cl_list` | `chunks` |
  | `cl_add` | `chunkadd` |
  | `cl_remove` | `chunkfree` |
  | `cl_slot` | `chunkslot` |

  `/trigger chunks set 1` is now the single command a player needs; everything
  else is reachable from the menu it prints. Typing `/trigger ` and pressing Tab
  lists the set, so the feature is discoverable without documentation.

  Existing installs are migrated on load (`setup_version` 3): the new objectives
  are created and the old ones removed, so tab-completion shows one coherent set
  rather than two.

- Freeing a claim from the menu now reprints the menu, so the next click is
  always against current numbering and the stale-key path became a corner case
  instead of routine.
- Add and remove confirmations carry a `[my chunks]` button back into the menu.

### Tooling

- `verify.sh` fails on an objective that is used but never created in
  `setup.mcfunction` - the exact bug that would have shipped dead `[free]`
  buttons to every existing install.
- `verify.sh` checks the migration chain: every `migrate/vN` is called from
  `load`, sets its own version, and `setup.mcfunction` seeds the newest.
