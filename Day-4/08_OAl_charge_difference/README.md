---
title: "08: Charge-density difference of O on Al(001)"
---
# 08: Charge-density difference, O/Al(001)-2x2

**Goal:** show where electrons move when O binds to Al(001):

Δn(r) = n_O/Al(001)(r) − [ n_O(r) + n_Al(001)(r) ]

| File | Purpose |
|------|---------|
| `OAl.in` | O/Al(001) slab (same as Example 07) |
| `OAl_difden.pwtk` | Relaxation, then the DIFDEN workflow |

## Run

```bash
pwtk OAl_difden.pwtk
```

## What the script does

1. **Relax** the structure (`relax.OAl001-2x2`). `input_pushpop` keeps `calculation='relax'` from affecting later steps.
2. Load the relaxed coordinates (`ATOMIC_POSITIONS_fromPWO`).
3. **DIFDEN**: three SCF + pp.x runs, for the full system (weight +1), the O atom alone (−1, spin-polarised via `difden_segmentSpec`) and the Al slab alone (−1). It then combines the densities.

## Outputs

* `difden.OAl001-2x2.xsf`: the 3D Δn(r)
* `relax.OAl001-2x2.out`: relaxation output

## Visualise

```bash
xcrysden -r 2 --xsf difden.OAl001-2x2.xsf
```

In XCrySDen, open *Tools → Data Grid* and plot **±isosurfaces** (for example ±0.005).

## Result analysis

1. **Accumulation** (Δn > 0) around O, and **depletion** (Δn < 0) on the neighbouring Al atoms: charge moves from Al to O.
2. How much did O move during the relaxation? Compare z in `OAl.in` (0.8385 alat) with the last `ATOMIC_POSITIONS` in `relax.OAl001-2x2.out`.
3. Is this picture consistent with the Bader charges from Example 07?
