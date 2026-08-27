# Player commands

Three commands. No permissions needed, no mods to install.

Datapacks cannot add new slash commands, so everything runs through vanilla's
`/trigger`. The wording is fixed - `set 1` is part of the command.

## Claim the chunk you are standing in

```text
/trigger cl_add set 1
```

Stand anywhere inside the chunk you want kept loaded and run it. The chunk stays
loaded even when you log off.

You will be refused if:

- you already claimed this chunk;
- you are already using all your slots (4 by default);
- an admin has paused new claims;
- you are in a dimension that is not open for claims.

## Release a claim

```text
/trigger cl_remove set 1
```

Stand inside a chunk you claimed and run it. That frees the slot immediately, so
you can go claim somewhere else straight away.

If another player also claimed the same chunk, it stays loaded for them. You only
give up your own hold on it.

## See your claims

```text
/trigger cl_list set 1
```

Prints your slot usage and every chunk you own:

```text
[ChunkLoader] Your chunks: 3 / 4 slots used
  1. Overworld  chunk X 12, Z -4
  2. Overworld  chunk X 13, Z -4
  3. Nether  chunk X 25, Z 8
```

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
