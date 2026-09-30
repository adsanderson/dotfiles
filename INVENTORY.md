# Current environment inventory

Inspected on Omarchy 4.0.4. This is an intentional-tool inventory, not a package dump.

| Setting/tool | Current source | Proposed owner | Portable? | Action |
|---|---|---|---|---|
| Bash startup | `~/.bashrc` sources `/usr/share/omarchy/default/bash/rc` | Home Manager common | Yes | Replace the Omarchy dependency with a small portable Bash config while retaining the used aliases, history behavior, completions, mise, starship, zoxide, and fzf integration. |
| Shell aliases/functions | Omarchy `default/bash/{aliases,fns}`; no personal overrides | Home Manager common | Mostly | Keep navigation, eza, fzf, Git, tmux, Herdr, compression, worktree, and SSH-forwarding helpers. Discard only Omarchy launchers and destructive drive helpers that have no portable use. |
| Shell PATH | Omarchy, mise activation, `~/.local/bin`, plus manual OpenCode/Turso paths | Home Manager common + mise global | Mostly | Keep `~/.local/bin` and mise activation. Do not preserve duplicate/generated PATH entries; vendor-only tools can add their own path when intentionally installed. |
| Readline behavior | `/usr/share/omarchy/default/bash/inputrc` | Home Manager common | Yes | Copy the useful completion and history-search behavior to editable `config/shell/inputrc`. |
| zsh startup | `~/.zshrc` from the Omaterm installer, sourcing unmanaged `~/.config/shell/*` | Home Manager common + bootstrap `chsh` | Yes | zsh is the login shell. `config/shell/zshrc` mirrors `bashrc` and `inputrc`; shared functions load under sticky ksh emulation so their bash-style arrays keep working. |
| Neovim / LazyVim | `~/.config/nvim` | Home Manager common | Yes | Preserve as an out-of-store symlink. Keep personal theme, remote clipboard, disabled animated scrolling, and selected LazyVim extras; discard only generated runtime data. |
| tmux | `~/.config/tmux/tmux.conf` | Home Manager common | Yes | Preserve as an out-of-store symlink, including pane/window controls and OSC 52 forwarding. |
| Herdr | `~/.config/herdr/config.toml`; binary is an explicit native package | Home Manager common (config and binary) | Yes | Preserve the tmux-equivalent workspace, tab, pane, key, theme, and UI behavior as an out-of-store symlink. Default multiplexer: zsh auto-starts or reattaches to the persistent session. The binary now comes from the pinned nixpkgs; remove the native package to avoid a second copy. |
| Git identity and defaults | Split between `~/.gitconfig` and `~/.config/git/config` | Home Manager common | Yes | Consolidate into editable `config/git/config`; keep global ignore. Resolve the conflicting default branch in favor of `main`, which is the current effective personal setting. |
| lazygit | Empty `~/.config/lazygit/config.yml` | Home Manager common | Yes | Do not carry an empty file; install the tool only. Add config later when there is an actual override. |
| Starship | `~/.config/starship.toml` | Home Manager common | Yes | Preserve as an out-of-store symlink. |
| Core CLI (`bat`, `btop`, `eza`, `fd`, `fzf`, `git`, `jq`, `lazygit`, `neovim`, `ripgrep`, `starship`, `tmux`, `zoxide`) | Explicit pacman packages | Home Manager common | Yes | Install through Home Manager on all profiles. Preserve btop's intentional layout, sorting, Vim keys, and custom theme without copying its generated default-filled config. Native copies may coexist during migration. |
| mise binary | Explicit `mise-bin` package | Home Manager common | Yes | Install through Home Manager; retain mise as runtime/tool manager. |
| AI/dev CLIs (`claude`, `codex`, `gemini`, `oh-my-pi`) | Global `~/.config/mise/config.toml` | mise global | Yes | Preserve at `latest` for simple `mise upgrade`; add OpenCode through its supported mise registry backend. Preserve only OpenCode's authored update and TUI settings; omit generated package metadata, locks, and backups. |
| GitHub CLI | Global mise `gh` plus native `github-cli` history; `~/.config/gh/config.yml` | Home Manager common | Yes | Move the binary to Home Manager and preserve portable preferences and aliases. Never migrate credential-bearing `hosts.yml`. |
| Go | Global mise `go = latest` | repo mise | Yes | Remove from global config. Repositories should declare the Go version they require. |
| uv | Global mise `uv = latest` and an older standalone install | mise global | Yes | Keep globally as a fast-moving Python project/tool manager; projects still declare Python and project tools in their own `mise.toml`. |
| Node, pnpm, Python | mise installs; pnpm selected by `~/repos/mise.toml` | repo mise | Yes | Do not add runtimes to Home Manager or global mise. Keep repository/directory-level version ownership, while retaining the portable Bash completion adapter for pnpm when the command is available. |
| Personal scripts | `~/.local/bin`; mostly generated tool launchers | leave alone | Mixed | Do not copy generated wrappers. Migrate only the authored `kvm-toggle` script to desktop `bin`. |
| Hyprland personal overrides | `~/.config/hypr/*.lua`; layered over `/usr/share/omarchy/default/hypr` | Home Manager desktop | No | Preserve only explicit overrides: 1.25 monitor scale and `SUPER+M` KVM binding. Keep Omarchy as the runtime/default provider on this laptop; do not fork its full defaults. |
| Hyprland relied-on defaults | `/usr/share/omarchy/default/hypr`; verified active bindings and clean config | pacman/OS | No | Leave with Omarchy/OS. The desktop module links override files alongside the existing baseline rather than copying default behavior. |
| Hyprland legacy `.conf` files/backups | `~/.config/hypr`; no longer loaded by active Lua entrypoint | discard | No | Do not migrate. Keep existing files untouched on disk during incremental migration. |
| Omarchy shell/bar | `~/.config/omarchy/shell.json` over packaged shell defaults | Home Manager desktop | No | Preserve explicit Tailscale widget, clock life data, and effectively-disabled idle lock. Keep Quickshell/Omarchy itself OS-owned. |
| Waybar | Only an Omarchy upgrade backup remains; no active Waybar config/process | discard | No | Do not revive or migrate it. Current Omarchy uses its Quickshell shell/bar. |
| Terminal settings | `xdg-terminal-exec` selects `foot.desktop`; Alacritty is an authored fallback; Ghostty/Kitty are not selected | Home Manager desktop (config), pacman/OS (binaries) | Mostly | Preserve active Foot behavior and the authored Alacritty fallback, including Omarchy theme includes, terminal key encodings, padding, and fonts. Leave unused Ghostty/Kitty configs alone. |
| Compose sequences | `~/.XCompose` extends the Omarchy defaults with personal identification shortcuts | Home Manager desktop | No | Preserve as desktop-only because its include path depends on Omarchy. |
| KVM monitor switching | `~/.local/bin/kvm-toggle`, bound to `SUPER+M` | Home Manager desktop | No | Preserve as desktop-only; `ddcutil` remains OS-owned because it needs hardware and system permissions. |
| Omarchy hooks/extensions/themes | Mostly packaged samples; one packaged update hook; empty plugin dir; Aether theme state | leave alone | No | Do not copy samples or generated/theme state. Keep current laptop files untouched. |
| User systemd units | All enabled units are supplied by Omarchy/Arch packages | pacman/OS | No | Do not recreate them in Home Manager. WSL/server profiles enable none. |
| PipeWire, portals, Bluetooth, Hyprland, display stack, fonts, GUI apps, Docker services | Explicit native packages/services | pacman/OS | No | Leave to native OS package management. |
| WSL environment | Not present on this host | Home Manager WSL | Profile-specific | Add only safe WSL defaults (`BROWSER=wslview` when available); no desktop or user services. |
| Headless environment | Not present on this host | Home Manager server | Profile-specific | Reuse common terminal environment with no desktop dependencies. |

## Ambiguous decisions resolved

- **Waybar vs Omarchy shell:** the active desktop uses Omarchy's Quickshell shell and no current `~/.config/waybar`; the old Waybar tree is an upgrade backup. It is discarded from the new repository.
- **Desktop portability:** Hyprland and Omarchy shell files are machine-family-specific and still depend on OS-provided Omarchy Lua/Quickshell defaults. They belong only to `desktop`, not `common`.
- **Terminal breadth:** `xdg-terminal-exec --print-id` selects Foot, not Alacritty. Foot and the authored Alacritty fallback are owned; copying inactive Ghostty/Kitty variants would add maintenance without restoring active behavior.
- **Git config conflict:** `master` appears in the XDG file while `main` appears in personal `~/.gitconfig`; the consolidated config uses `main`.
- **mise scope:** AI CLIs, OpenCode, and uv stay global because they update rapidly. GitHub CLI becomes Home Manager-owned. Go, Node, pnpm, and Python versions remain repository/directory-owned.
- **Idle lock:** `315360000` seconds is treated as an intentional effective disable and retained only in the desktop override.
- **Excluded application state:** GitHub `hosts.yml` and GnuPG state are sensitive; OpenCode lock/package files and fish's uv environment are generated; qalc's config is application state; `hyprmoncfg` is hardware-specific. None are migrated.
