---
title: "02: Si convergence tests"
---
# 02: Convergence tests for bulk Si

**Goal:** find converged values of **k-points**, **ecutwfc** and **ecutrho (dual)**, and see how **smearing/degauss** affect the total energy.

| File | Purpose |
|------|---------|
| `Si.in` | Starting pw.x input (loaded with `load_fromPWI`) |
| `Si_convergence.pwtk` | Three automated scans and their plots |

## Run

```bash
pwtk Si_convergence.pwtk
```

The script runs about **68 pw.x calculations**. Thanks to `restart on`, you can stop it with `Ctrl+C` and run it again: finished runs are skipped.
Each scan is inside `input_pushpop { }`, so it starts from the original `Si.in` values and changes **one parameter at a time**.

## What the script does

| Scan | Varies | Output data | Plot |
|------|--------|-------------|------|
| 1 | k = 4, 8, 12, 16, 20 (k×k×k mesh) | `k.Si.dat` | `k.Si.png` |
| 2 | ecutwfc = 25 to 45 Ry for dual = 4, 8, 12 | `ecut.Si.dual*.dat` | `ecut.Si.dual4.png` |
| 3 | degauss = 0.01 to 0.09 for gauss / m-p / m-v at k = 4 to 16 | `gauss.Si.k*.dat`, ... | multiplot `*.png` |

Each `.dat` file has two columns: *parameter*, *total energy (Ry)*.

## Result analysis

1. **k-points:** from `k.Si.dat`, find the smallest k for which the energy changes by less than **1 mRy** (0.001 Ry) compared with the next k.
2. **ecutwfc:** find the cutoff where the energy is converged to about 1 mRy/atom. Does dual = 4 or 8 matter? (Hint: dual 4 is enough for norm-conserving pseudopotentials; ultrasoft ones need 8 to 12.)
3. **Smearing:** the energy depends on degauss. Which method (gauss, m-p, m-v) depends on degauss the least?
4. **Si is a semiconductor** with a norm-conserving (`pz-vbc`) pseudopotential. Expect fast k-convergence (about 8×8×8), insensitivity to dual, and **almost no effect of smearing**, because there are no states at the Fermi level. Smearing is switched on only in scan 3, to show this.

Quick table of all runs: `bash ../qejob_info.sh`
