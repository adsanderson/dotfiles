# Dotfiles

Portable terminal and development configuration for three standalone Home Manager profiles:

- `laptop`: common terminal environment plus Omarchy/Hyprland desktop overrides
- `work-wsl`: common terminal environment plus small WSL environment adjustments
- `server`: common terminal environment with no desktop dependencies

The repository must be cloned at `~/dotfiles`. See [INVENTORY.md](INVENTORY.md) for the inspected source, ownership decision, and migration action for the current Omarchy machine.

Profile usernames are declared beside the targets in `flake.nix`. They currently use `adams`; change the relevant target there before onboarding a machine with a different account name.

## Ownership model

### Native OS package manager

The OS owns the machine: Hyprland, the Omarchy shell/Quickshell, Wayland portals, PipeWire, display/login tools, drivers, Bluetooth, Docker and other system services, GUI applications, and desktop fonts. This repository does not turn Arch, WSL, or a VPS into NixOS.

The laptop profile configures user-facing parts of an existing Omarchy installation. It does not install or reproduce Omarchy. In particular, `config/hypr/hyprland.lua` deliberately loads the OS-provided Omarchy defaults and then applies the small overrides in this repository.

### Home Manager

Home Manager owns stable portable CLI programs and user configuration:

- zsh (login shell, set by bootstrap) and Bash, Git, Neovim, tmux, Herdr configuration, btop, lazygit, fzf, ripgrep, fd, jq, zoxide, starship, mise, bat, eza, and GitHub CLI
- editable files under `config/`, including portable GitHub CLI and OpenCode preferences
- desktop-only terminal, Compose, Hyprland, Omarchy shell, and `kvm-toggle` configuration

Herdr is the default multiplexer: Home Manager installs it from the pinned nixpkgs, and interactive zsh starts or reattaches to the persistent session in plain terminals (not inside tmux, Herdr, or VS Code). Set `HERDR_AUTOSTART=0` to skip it for one terminal.

Most terminal behavior is in `home/common.nix`. `home/desktop.nix`, `home/wsl.nix`, and `home/server.nix` contain explicit profile differences.

### mise

`config/mise/config.toml` owns fast-moving global developer CLIs: Claude Code, Codex, Gemini CLI, OpenCode, oh-my-pi, and uv. Run `mise up` to update them. `MISE_UPGRADE_AUTO_PRUNE=false` is exported by Home Manager so old tool versions remain until an explicit `mise prune`.

A repository owns its language/runtime versions. Node, pnpm, Python, Go, Terraform, and project-specific tools belong in that repository's `mise.toml`, not in `home/packages.nix` or the global mise config.

Example project config:

```toml
[tools]
node = "24"
pnpm = "10"
python = "3.13"
uv = "latest"
```

Then run:

```bash
mise trust
mise install
```

## Bootstrap a machine

Install the OS first, including `git` and `curl`, then:

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./bootstrap
```

Profile detection chooses:

1. `work-wsl` when the kernel identifies WSL
2. `laptop` when Omarchy is installed or the current session is Hyprland
3. `server` otherwise

Select explicitly when detection is not what you want:

```bash
./bootstrap laptop
./bootstrap work-wsl
./bootstrap server
```

The bootstrap installs only Nix when it is missing, runs the repository-pinned standalone Home Manager, then installs global mise tools. Managed zsh and Bash login and interactive startup source the single-user Nix profile, so later bootstrap runs reuse the installation. Home Manager cannot change the login shell, so the bootstrap runs `chsh` to the system zsh from `/etc/shells` when run from a terminal, and otherwise prints the command. The bootstrap does not install desktop or system packages. Before activation, Home Manager's supported `-b` option renames colliding regular files and directories with a timestamped `hm-backup-*` extension instead of deleting them. Home Manager deliberately refuses to back up foreign symlinks, so the managed `.inputrc` explicitly replaces an existing link while leaving that link's target untouched. Inspect without changing anything:

```bash
./bootstrap laptop --check
```

### Container smoke test

With a working Docker daemon, exercise the fresh-user `work-wsl` bootstrap in an Arch container:

```bash
./tests/container-bootstrap
```

The build installs Nix through `bootstrap`, activates Home Manager twice, verifies representative managed links, confirms that a pre-existing Git config is backed up exactly once, exercises the `.inputrc` foreign-symlink cutover, and proves reactivation is idempotent. It empties the mise tool list only inside the image so the bootstrap test does not download unrelated third-party CLIs.

A container does not emulate the WSL kernel, Windows interop, systemd, or `wslview`. It validates the Arch userspace, Nix installation, Home Manager activation, and collision handling; the real WSL instance still needs a final smoke run.

### Laptop prerequisites

Use pacman/Omarchy for the desktop stack. The migrated overrides specifically expect:

- Omarchy and Hyprland for the Lua default layer
- Foot or Alacritty and their Omarchy theme state
- `ddcutil` and working DDC permissions for `kvm-toggle`
- JetBrains Mono and Caskaydia Mono Nerd Fonts for the configured terminals

Home Manager intentionally does not enable or replace current user systemd units. Existing Omarchy configuration remains untouched until bootstrap or `home-manager switch` is explicitly run from `~/dotfiles`; bootstrap retains timestamped backups of colliding files.

### WSL prerequisites

Use an Arch-based WSL distribution with `git` and `curl`. The profile installs no desktop stack and no user services. When `wslview` is already available, it becomes `BROWSER`; otherwise no browser integration is forced.

If activation stops during `checkLinkTargets`, no managed links have been changed yet; correct the reported ownership conflict and rerun `./bootstrap work-wsl`. A completed Nix installation is reused automatically.

### VPS prerequisites

Create the normal user, install `git` and `curl`, clone to `~/dotfiles`, and run `./bootstrap server`. The profile contains no graphical package or service.

## Apply and update

Apply a profile directly:

```bash
home-manager switch --flake ~/dotfiles#laptop
home-manager switch --flake ~/dotfiles#work-wsl
home-manager switch --flake ~/dotfiles#server
```

Update Home Manager and Nix packages:

```bash
cd ~/dotfiles
nix flake update
home-manager switch --flake .#laptop  # choose this machine's profile
```

Update global mise-managed tools:

```bash
mise up
mise prune
```

Project runtimes are updated from inside that project, after editing its `mise.toml`:

```bash
mise install
```

## Editable out-of-store links

Home Manager normally copies file content into the immutable Nix store. These modules instead use `config.lib.file.mkOutOfStoreSymlink` for actively edited configuration. For example:

```nix
"nvim".source = config.lib.file.mkOutOfStoreSymlink
  "${config.home.homeDirectory}/dotfiles/config/nvim";
```

After one profile activation, `~/.config/nvim` points at `~/dotfiles/config/nvim`. Editing `~/dotfiles/config/nvim/init.lua` takes effect immediately; another `home-manager switch` is unnecessary. A switch is required when changing Nix modules, package lists, profile membership, or adding/removing managed links.

The stable `~/dotfiles` path is an invariant. Do not activate this flake from another checkout path and expect the editable links to follow it.

## Add configuration

### Add a dotfile

1. Put its editable source under `config/<tool>/`.
2. Add an out-of-store link in `home/common.nix` or the appropriate profile module.
3. Apply that profile once.

Example:

```nix
xdg.configFile."mytool".source = outOfStore "config/mytool";
```

Use a normal Home Manager-managed file for tiny generated/static values that are not edited directly.

### Add a stable portable CLI

Add its nixpkgs attribute to `home/packages.nix`, then apply the profile:

```nix
home.packages = with pkgs; [
  # existing packages
  shellcheck
];
```

Desktop applications and tools requiring system integration remain native OS packages.

### Add a fast-moving global CLI

Add it to `[tools]` in `config/mise/config.toml`, using `mise registry <name>` to confirm the backend, then run `mise install`. Do not put language versions there merely for convenience.

### Add a repository-specific tool

Create or edit that project's `mise.toml` and commit it with the project. This dotfiles repository should not know which Node, Python, Go, pnpm, or Terraform version another repository requires.

## Migration safety

The initial migration copied selected source into this repository; it did not delete, replace, or refresh anything under the current home directory. The old Waybar directory is an Omarchy upgrade backup, not active configuration, so it was not migrated. Likewise, packaged Omarchy samples, generated wrappers in `~/.local/bin`, old Hyprland `.conf` files, inactive Ghostty/Kitty variants, package-provided systemd units, OpenCode package/lock files, qalc application state, hardware-specific `hyprmoncfg`, GnuPG state, and credential-bearing GitHub `hosts.yml` remain outside this repository.
