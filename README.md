# PWTK 2026

Course material for the PWTK 2026 workshop.

## Getting the material

Inside your VirtualBox VM, clone this repository once:

```bash
git clone https://github.com/sairajdream/pwtk2026.git
cd pwtk2026
```

Each time new material is added, pull the latest changes:

```bash
cd pwtk2026
git pull
```

## Contents

| Folder | Contents |
| ------ | -------- |
| `Day-1` | Linux & Vim basic commands, VM setup guide, Quantum ESPRESSO install script |

## Day-1

- `Linux&Vim Basic commands.pdf` — reference sheet for the shell and Vim
- `vm2026.pdf` — VirtualBox / VM setup instructions
- `qeinstall.sh` — installs Quantum ESPRESSO 7.5 and its prerequisites

To run the installer:

```bash
cd Day-1
chmod +x qeinstall.sh
./qeinstall.sh
```

The script installs into `$HOME/espresso` and appends the QE `bin` directory to
your `~/.bashrc`. Edit the `QElink`, `VER`, and `IDIR` variables at the top if
you want a different version or install path, and change `make -j 4` to match
the number of CPU cores you gave the VM.
