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
| Herdr | `config/herdr/config.toml` | Home Manager common | Yes | Install from pinned nixpkgs and preserve workspace, tab, pane, key, theme, and UI behavior. |
| Git identity and defaults | `config/git/config` | Home Manager common | Yes | Keep the consolidated editable config and global ignore. The default branch is `main`. |
| lazygit | No authored configuration | Home Manager common | Yes | Install the tool only. Add configuration only for an actual override. |
| Starship | `config/starship/starship.toml` | Home Manager common | Yes | Preserve as an out-of-store symlink. |
| Core CLI (`bat`, `btop`, `eza`, `fd`, `fzf`, `git`, `jq`, `lazygit`, `neovim`, `ripgrep`, `starship`, `tmux`, `zoxide`) | `home/packages.nix` | Home Manager common | Yes | Install through Home Manager on all profiles. |
| mise binary | `home/packages.nix` | Home Manager common | Yes | Retain mise as the runtime/tool manager. |
| AI/dev CLIs (`claude`, `codex`, `gemini`, `oh-my-pi`) | `config/mise/config.toml` | mise global | Yes | Keep fast-moving CLIs at `latest`; preserve only authored configuration. |
| GitHub CLI | `home/packages.nix`; `config/gh/config.yml` | Home Manager common | Yes | Preserve portable preferences and aliases. Never migrate credential-bearing `hosts.yml`. |
| Go, Node, pnpm, Python | Repository `mise.toml` files | Each repository | Yes | Do not add language runtimes to Home Manager or global mise. |
| uv | `config/mise/config.toml` | mise global | Yes | Keep globally as a project/tool manager; projects still declare their Python version and tools. |
| Personal scripts | `bin` | Profile-specific | Mixed | Manage only authored scripts; do not copy generated wrappers. |
| Hyprland and desktop shell | Native system configuration | Native OS | No | Do not manage distribution-provided desktop configuration in this repository. |
| Terminal settings | `config/foot`; `config/alacritty` | Home Manager desktop | Mostly | Preserve standalone key encodings, padding, fonts, and OSC 52 behavior. |
| Compose sequences | `config/xcompose/XCompose` | Home Manager desktop | Yes | Extend the standard locale definitions with personal identification shortcuts. |
| KVM monitor switching | `bin/kvm-toggle` | Home Manager desktop | No | Preserve the utility; `ddcutil` remains OS-owned because it needs hardware and system permissions. |
| User systemd units | Package-provided units | Native OS | No | Do not recreate them in Home Manager. WSL/server profiles enable none. |
| PipeWire, portals, Bluetooth, Hyprland, display stack, fonts, GUI apps, Docker services | Native packages/services | Native OS | No | Leave to native OS package management. |
| WSL environment | `home/wsl.nix` | Home Manager WSL | Profile-specific | Add only safe WSL defaults (`BROWSER=wslview` when available); no desktop or user services. |
| Headless environment | `home/server.nix` | Home Manager server | Profile-specific | Reuse the common terminal environment with no desktop dependencies. |

## Decisions

- **Desktop portability:** system desktop and shell configuration stays outside the repository; the laptop profile contains only standalone user configuration.
- **Terminal breadth:** Foot is the primary terminal and Alacritty is the authored fallback. Inactive terminal variants are not copied.
- **mise scope:** AI CLIs, OpenCode, and uv stay global because they update rapidly. Go, Node, pnpm, and Python versions remain repository-owned.
- **Excluded application state:** GitHub `hosts.yml` and GnuPG state are sensitive; generated package metadata, locks, backups, and application state are not migrated.
