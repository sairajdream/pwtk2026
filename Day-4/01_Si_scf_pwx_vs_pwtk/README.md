---
title: "01: Si SCF with pw.x and with PWTK"
---
# 01: Si SCF with pw.x and with PWTK

**Goal:** run the same self-consistent (SCF) calculation for bulk Si in two ways, (a) plain `pw.x` and (b) PWTK, and compare.

| File | Purpose |
|------|---------|
| `Si_scf.in`   | Classic Quantum ESPRESSO input (namelists `&CONTROL ... /`) |
| `Si_scf.pwtk` | The same input in PWTK syntax (`CONTROL { ... }`) + `runPW` |

## Step A: plain pw.x

```bash
mpirun -np 2 ~/espresso/qe6.7/bin/pw.x -in Si_scf.in > Si_scf.out
grep ! Si_scf.out
```

`pseudo_dir` is not set, so pw.x uses its default, `~/espresso/pseudo`.

## Step B: PWTK

```bash
pwtk Si_scf.pwtk
```

PWTK writes `pwtk.Si_scf.in`, runs `pw.x` on it (using `prefix`/`bin_dir` from `~/.pwtk/pwtk.tcl`), writes `pwtk.Si_scf.out` and prints the total energy.

## What to compare

* `diff Si_scf.in pwtk.Si_scf.in`: PWTK evaluated `4*18.0 → 72.0` and `1/4 → 0.25` for you.
* Both runs should give the **same total energy** (about −15.84 Ry, LDA, 18 Ry cutoff).
* Visualise the structure: `xi Si_scf.in`, or `xo Si_scf.out`.

## Result analysis

1. How many SCF iterations were needed? (`grep "convergence has been achieved" *.out`)
2. How many electrons and Kohn–Sham states? (`bash ../qejob_info.sh`)
3. Why is PWTK useful? The input is now a *Tcl script*. You can loop over parameters, read results back and plot them, which is what the next examples do.
