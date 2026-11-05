---
title: "Day 5: Automated DFT with PWTK"
---

**Hands-on session: 8 examples.**

Every example works the same way:

```bash
cd 0X_folder_name
pwtk  <script>.pwtk
```

Each folder has its own `README.md` / `README.html` with the exact command,
what the script does, which files it produces, and how to read the results.

---

## 0. Before you start

### 0.1 Aliases and PATH (only once)

```bash
echo "alias xi='xcrysden --pwi'"  >> ~/.bashrc     # view a pw.x input
echo "alias xo='xcrysden --pwo'"  >> ~/.bashrc     # view a pw.x output
echo "alias xsf='xcrysden --xsf'" >> ~/.bashrc     # view an XSF file
echo 'export PATH="$PATH:$HOME/espresso/pwtk-3.2"' >> ~/.bashrc   # 'pwtk' command
bash        # reload (or open a new terminal)
```

> Be careful when you edit `~/.bashrc`. A mistake there can break your shell.
> To edit it by hand, run `vim ~/.bashrc`, make the change, then type `:wq` to save and quit.

### 0.2 One global PWTK configuration: `~/.pwtk/pwtk.tcl`

You do **not** need to set `pseudo_dir` or the path to `pw.x` in the examples.
Everything comes from the one PWTK configuration file:

```bash
cat ~/.pwtk/pwtk.tcl
```

The important lines are:

```tcl
prefix      "mpirun -np 2"                    ;# run QE on 2 MPI processes (4 physical cores)
bin_dir     $env(HOME)/espresso/qe6.7/bin/    ;# where pw.x, pp.x, dos.x ... live
pseudo_dir  $env(HOME)/espresso/pseudo        ;# where the .UPF files live
outdir_prefix  /tmp/QE                        ;# scratch (when outdir is not set)
```

### 0.3 Check the pseudopotentials

All examples need these files in `~/espresso/pseudo`:

---

## 1. Examples

| #  | Folder | Command | What you learn |
|----|--------|---------|----------------|
| 01 | [`01_Si_scf_pwx_vs_pwtk`](01_Si_scf_pwx_vs_pwtk/README.md) | `pw.x` and `pwtk Si_scf.pwtk`  | Same SCF run with plain pw.x and with PWTK     |
| 02 | [`02_Si_convergence`](02_Si_convergence/README.md) | `pwtk Si_convergence.pwtk`     | k-points, ecutwfc and dual scans with plots    |
| 03 | [`03_Cu_convergence`](03_Cu_convergence/README.md) | `pwtk Cu_convergence.pwtk`     | The same scans for a metal, plus smearing      |
| 04 | [`04_Fe_dos`](04_Fe_dos/README.md) | `pwtk Fe_dos.pwtk`             | SCF, NSCF and dos.x: spin-polarised DOS        |
| 05 | [`05_Fe_pdos`](05_Fe_pdos/README.md) | `pwtk Fe_pdos.pwtk`            | projwfc.x: projected DOS (s, d, t2g/eg)        |
| 06 | [`06_Fe_bands`](06_Fe_bands/README.md) | `pwtk Fe_bands.pwtk`           | Band structure next to the DOS                 |
| 07 | [`07_OAl_bader`](07_OAl_bader/README.md) | `pwtk OAl_bader.pwtk`          | Bader charges for O on Al(001)                 |
| 08 | [`08_OAl_charge_difference`](08_OAl_charge_difference/README.md) | `pwtk OAl_difden.pwtk`         | Relaxation, then the charge-density difference Δn(r) |


---

## 2. General workflow for each example

1. `cd` into the folder and read its `README`.
2. Open the input (`*.in` or `*.pwtk`) and find the parameters the README mentions.
3. Run `pwtk <script>.pwtk`.
4. Look at the results: `*.png` / `*.pdf` plots, `*.dat` tables, and `*.out` files.
5. Answer the "Result analysis" questions in the README.

### Useful helpers

```bash
bash ../qejob_info.sh        # table of energy, cutoffs, k-points, magnetisation and wall time for every *.out file here
grep ! *.out                 # final total energies
grep "Fermi" *.out           # Fermi energies
xo  scf.out                  # view the structure from an output file
```

`restart on` is set in the convergence scripts. If you re-run a script,
calculations that already finished are skipped, so it is safe to start again.

---

## 3. Troubleshooting

| Problem | Fix |
|---------|-----|
| `pwtk: command not found` | Do step 0.1, or use the full path `~/espresso/pwtk-3.2/pwtk` |
| `Error reading pseudo` / file not found | Do step 0.3 |
| `bader: command not found` (Example 07) | Install the Henkelman `bader` program and put it in your `PATH` |
| Plot window closes or does not appear | Look at the `*.png` / `*.pdf` files that PWTK writes in the folder |
| Want to start from scratch | Delete the generated `*.in`, `*.out` and `*.dat` files (keep the original inputs) |

PWTK documentation: <https://pwtk.ijs.si>. 
