---
title: "05: Projected DOS of bcc Fe"
---
# 05: Projected DOS (PDOS) of bcc Fe

**Goal:** split the DOS into atomic-orbital contributions (s, d, t2g, eg, individual d orbitals) with `pdos_run` (pw.x SCF, then NSCF, then projwfc.x).

| File | Purpose |
|------|---------|
| `Fe.pwtk` | bcc Fe input data (same as Example 04) |
| `Fe_pdos.pwtk` | `pdos_run`, then `sumpdos`/`sumldos`, then `pdos_multiplot` |

## Run

```bash
pwtk Fe_pdos.pwtk
```

## Outputs

* `Fe.pdos_atm#1(Fe)_wfc#*`: raw projwfc.x PDOS files
* `Fe-s.pdos`, `Fe-d.pdos`, `Fe-total.ldos`: summed, simpler files
* a **PDF** with 6 panels (total/s/d, t2g vs eg, dz², dx²−y², dzx+dzy, dxy), plus a plot window

## Result analysis

1. Which orbitals dominate near E_F? (They should be the **d** orbitals; s is small and broad.)
2. bcc crystal field: **t2g** (dxy, dyz, dzx) and **eg** (dz², dx²−y²) have different shapes. Compare them.
3. Integrate up to E_F to estimate occupations. Look at the Löwdin charges at the end of `projwfc.Fe.out` (`grep -A3 "Lowdin Charges"`) and compare spin up with spin down for d.
