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
