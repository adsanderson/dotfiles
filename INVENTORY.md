# Current environment inventory

This is an intentional-tool inventory, not a package dump.

| Setting/tool | Current source | Owner | Portable? | Action |
|---|---|---|---|---|
| Bash startup | `config/shell/bashrc` | Home Manager common | Yes | Keep the portable aliases, history behavior, completions, mise, starship, zoxide, and fzf integration. |
| Shell aliases/functions | `config/shell/{aliases,functions}.sh` | Home Manager common | Mostly | Keep navigation, eza, fzf, Git, tmux, Herdr, compression, worktree, and SSH-forwarding helpers. |
| Shell PATH | Home Manager session path plus mise activation | Home Manager common + mise global | Mostly | Keep `~/.local/bin` and mise activation. Avoid duplicate or generated PATH entries. |
| Readline behavior | `config/shell/inputrc` | Home Manager common | Yes | Keep completion and history-search behavior in an editable file. |
| zsh startup | `config/shell/zshrc` | Home Manager common + bootstrap `chsh` | Yes | zsh is the login shell. Shared functions load under sticky ksh emulation so their bash-style arrays keep working. |
| Neovim / LazyVim | `config/nvim` | Home Manager common | Yes | Preserve as an out-of-store symlink. Keep personal theme, remote clipboard, disabled animated scrolling, and selected LazyVim extras. |
| tmux | `config/tmux/tmux.conf` | Home Manager common | Yes | Preserve as an out-of-store symlink, including pane/window controls and OSC 52 forwarding. |
| Herdr | `config/herdr/config.toml` | Home Manager common | Yes | Install from pinned nixpkgs and preserve workspace, tab, pane, key, theme, and UI behavior. Keep logs, sessions, plugin locks, release notes, and generated color files machine-local. |
| Git identity and defaults | `config/git/config` | Home Manager common | Yes | Keep the consolidated editable config and global ignore. The default branch is `main`. |
| lazygit | `config/lazygit/config.yml` | Home Manager common | Yes | Preserve the current portable theme override as an out-of-store symlink on every profile; exclude Noctalia's duplicate generated theme file. |
| Starship | `config/starship/starship.toml` | Home Manager common | Yes | Preserve as an out-of-store symlink. |
| Core CLI (`bat`, `btop`, `eza`, `fd`, `fzf`, `git`, `jq`, `lazygit`, `neovim`, `openssh`, `ripgrep`, `starship`, `tmux`, `zoxide`) | `home/packages.nix` | Home Manager common | Yes | Install through Home Manager on all profiles. |
| mise binary | `home/packages.nix` | Home Manager common | Yes | Retain mise as the runtime/tool manager. |
| AI/dev CLIs (`claude`, `codex`, `gemini`, `oh-my-pi`) | `config/mise/config.toml` | mise global | Yes | Keep fast-moving CLIs at `latest`; preserve only authored configuration. |
| GitHub CLI | `home/packages.nix`; `config/gh/config.yml` | Home Manager common | Yes | Preserve portable preferences, SSH Git protocol, and aliases. Never migrate credential-bearing `hosts.yml`. |
| SSH client and agent integration | `home/common.nix`; `home/desktop.nix` | Home Manager common + desktop environment | Mostly | Manage portable GitHub host settings everywhere and expose the package-provided agent socket on laptops. Keep private keys, `known_hosts`, socket enablement, and forwarded agents machine-local. |
| Go, Node, pnpm, Python | Repository `mise.toml` files | Each repository | Yes | Do not add language runtimes to Home Manager or global mise. |
| uv | `config/mise/config.toml` | mise global | Yes | Keep globally as a project/tool manager; projects still declare their Python version and tools. |
| Personal scripts | `bin` | Profile-specific | Mixed | Manage only authored scripts; do not copy generated wrappers. |
| Niri and Noctalia packages/system integration | Native system configuration | Native OS | No | Install and integrate the compositor and shell through CachyOS; Home Manager owns only the authored user configuration. |
| Terminal settings | `config/foot`; `config/alacritty` | Home Manager desktop | Mostly | Use JetBrains Mono Nerd Font in both terminals; preserve standalone key encodings, padding, and OSC 52 behavior. |
| Niri compositor configuration | `config/niri` | Home Manager CachyOS layer | No | Preserve the current includes, input/display/layout behavior, key bindings, Noctalia startup/integration, window rules, and CachyOS Niri blur settings as an out-of-store symlink. |
| Noctalia shell configuration | `config/noctalia` | Home Manager CachyOS layer | No | Preserve authored shell and lock-screen preferences as an out-of-store symlink. |
| 1Password desktop app | Official `1password` AUR package | Native OS | No | Install on the CachyOS laptop with `paru`; keep the application, browser integration, credentials, and state outside Home Manager and this repository. |
| VLC desktop app | Signed CachyOS `vlc` package | Native OS | No | Install on the CachyOS laptop with `pacman`; keep the application and its state outside Home Manager and this repository. |
| Laptop user font defaults | `home/desktop.nix` | Home Manager desktop | Yes | Install JetBrains Mono Nerd Font and use it for the per-user Fontconfig monospace, sans-serif, and serif defaults. |
| Compose sequences | `config/xcompose/XCompose` | Home Manager desktop | Yes | Extend the standard locale definitions with personal identification shortcuts. |
| KVM monitor switching | `bin/kvm-toggle` | Home Manager desktop | No | Preserve the utility; `ddcutil` remains OS-owned because it needs hardware and system permissions. |
| User systemd units | Package-provided units | Native OS | No | Do not recreate them in Home Manager. The laptop uses the package-provided SSH agent socket; WSL/server profiles enable none. |
| PipeWire, portals, Bluetooth, Niri and Noctalia packages, display stack, system-wide fonts, GUI apps, Docker services | Native packages/services | Native OS | No | Leave packages and system integration to native OS management. |
| WSL environment | `home/wsl.nix` | Home Manager WSL | Profile-specific | Add only safe WSL defaults (`BROWSER=wslview` when available); Windows owns the terminal font, and the profile enables no desktop or user services. |
| Headless environment | `home/server.nix` | Home Manager server | Profile-specific | Reuse the common terminal environment with no desktop dependencies. |

## Decisions

- **Desktop portability:** desktop packages, services, and system-wide font configuration stay native-OS-owned. The CachyOS layer owns this laptop's Niri and Noctalia user configuration; the reusable desktop layer owns terminal, Compose, utility, and per-user font configuration.
- **Terminal breadth:** Foot is the primary terminal and Alacritty is the authored fallback. Inactive terminal variants are not copied.
- **mise scope:** AI CLIs, OpenCode, and uv stay global because they update rapidly. Go, Node, pnpm, and Python versions remain repository-owned.
- **Excluded application state:** GitHub `hosts.yml` and GnuPG state are sensitive; generated package metadata, locks, backups, and application state are not migrated.
