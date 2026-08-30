# Player commands

No permissions needed, no mods to install.

Datapacks cannot add new slash commands, so everything runs through vanilla's
`/trigger`. The wording is fixed - `set 1` is part of the command.

## The only one worth memorising

```text
/trigger chunks set 1
```

This prints your chunks as a **clickable menu**:

```text
[ChunkLoader] Your chunks: 2 / 4 slots used
  1. Overworld  chunk X 12, Z -4    [free]
  2. Nether     chunk X 25, Z 8     [free]

  [+ Claim the chunk I am standing in]
```

Click `[free]` on any row to release that claim - from anywhere in the world, no
travelling required. Click the green button to claim the chunk you are currently
standing in. Hovering over a row shows its corner block coordinates.

If you are out of slots, or an admin has paused new claims, the claim button is
replaced by a line telling you why. A button is never shown when clicking it
would fail.

## Typed equivalents

The buttons run these for you. Use them directly if you prefer typing.

### Claim the chunk you are standing in

```text
/trigger chunkadd set 1
```

Stand anywhere inside the chunk you want kept loaded and run it. The chunk stays
loaded even when you log off.

You will be refused if:

- you already claimed this chunk;
- you are already using all your slots (4 by default);
- an admin has paused new claims;
- you are in a dimension that is not open for claims.

### Release the claim you are standing in

```text
/trigger chunkfree set 1
```

Stand inside a chunk you claimed and run it. That frees the slot immediately, so
you can go claim somewhere else straight away.

If another player also claimed the same chunk, it stays loaded for them. You only
give up your own hold on it.

## Why a stale menu refuses to act

Freeing a claim renumbers the rows below it. If you free row 1 and then click
`[free]` on row 2 of the *same* printout, row 2 no longer means what it did when
the menu was drawn.

Rather than release the wrong chunk, the datapack refuses:

```text
[ChunkLoader] That list was out of date, so nothing was changed. Here is the
current one:
```

...followed by a fresh menu. Click from the newest printout and this never comes
up. It exists so that a mis-click can never silently unload someone's farm.

## Finding out which chunk you are in

The list shows **chunk** coordinates, not block coordinates. Press F3 in game;
the `Chunk:` line shows your current chunk. A chunk is 16x16 blocks, so chunk
X 12 covers blocks X 192 through 207.

## Practical tips

- A farm that spans a chunk border needs a claim in **every** chunk it touches.
  Check with F3 before spending slots.
- Claim the chunk the machinery is in, not the chunk you stand in while looking
  at it.
- Claims survive restarts. You do not need to re-add them after the server
  reboots.
