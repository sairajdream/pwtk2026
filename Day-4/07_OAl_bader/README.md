---
title: "07: Bader charges of O on Al(001)"
---
# 07: Bader charge analysis, O/Al(001)-2x2

**Goal:** find how much charge moves from the Al surface to the adsorbed O atom, using **Bader** analysis (pw.x, then pp.x, then bader).

| File | Purpose |
|------|---------|
| `OAl.in` | 3-layer Al(001) 2×2 slab with one O adatom (13 atoms) |
| `OAl_bader.pwtk` | `pw_pp_bader -e 500 -p 0 bader.OAl001-2x2` |

Requires the `bader` program in your `PATH` (`which bader`).

## Run

```bash
pwtk OAl_bader.pwtk
```

`-e 500` sets `ecutrho = 500` (for production, use 1000); `-p 0` sets pp.x `plot_num = 0` (valence charge density).

## Outputs

* `ACF.dat`: Bader charge for each atom (the main result)
* `BCF.dat`, `AVF.dat`: Bader volumes
* the pw.x and pp.x `*.in`/`*.out` files and a `*.cube` density file

## Result analysis

1. `cat ACF.dat`: atom 1 is **O**. Its Bader charge should be well **above 6 e** (its valence), so **O gains about 1.5 to 2 e**.
2. Which Al atoms lose charge? (They should be the 4 top-layer Al atoms, numbers 2 to 5.)
3. Is the O–Al bond ionic or covalent? Compare with the charge-density difference in Example 08.
