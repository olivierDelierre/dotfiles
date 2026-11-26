# Olivier's .dotfiles

## Installation

On a Unix-like system, clone the repository and run:

```sh
./install.sh
```

The installer links home-level files into `$HOME` and application configs into
`${XDG_CONFIG_HOME:-$HOME/.config}`. Existing paths are preserved in
timestamped `.backup` paths. Re-running the installer is safe: links that
already point to this repository are left unchanged. At startup, choose whether
to install the PowerShell or ZSH profile.

Preview all changes without modifying the filesystem:

```sh
./install.sh --dry-run
```
