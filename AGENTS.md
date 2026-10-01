# Repository guidance

## Purpose and layout

This repository manages one user's portable terminal environment with standalone Home Manager profiles:

- `home/common.nix`: settings and tools shared by every machine.
- `home/desktop.nix`: laptop-only terminal, Compose, and utility links.
- `home/wsl.nix`: WSL-only environment adjustments.
- `home/server.nix`: headless-server adjustments.
- `config/`: editable configuration linked out of the Nix store.
- `bootstrap`: profile detection, Nix installation, Home Manager activation, and mise installation.

Read `README.md` for operation and `INVENTORY.md` before changing ownership or migration decisions.

## Invariants

- The checkout path is `~/dotfiles`. `home/common.nix` and `home/desktop.nix` intentionally create out-of-store links through that stable path.
- Home Manager owns stable portable CLI packages and configuration.
- `config/mise/config.toml` owns fast-moving global developer CLIs. Repositories own language runtimes and project-specific tools.
- The native OS owns desktop infrastructure, services, drivers, GUI applications, and the desktop shell.
- Desktop configuration must not depend on distribution-provided configuration files.
- Do not add credentials, generated state, caches, lock backups, OMP sessions/databases, or GitHub `hosts.yml`.
- Reuse the existing out-of-store-link and profile patterns instead of introducing another configuration owner.

## Verification

Run the narrowest relevant checks, then the behavioral check for significant changes:

- All Home Manager profiles: `nix flake check`
- Bootstrap selection and path validation: `./bootstrap <laptop|work-wsl|server> --check`
- Fresh-user activation and idempotence: `./tests/container-bootstrap` (requires Docker and is the slow integration check)

Changes to bootstrap, activation, collision handling, or managed links require the container smoke test. Desktop-only behavior that depends on Hyprland, DDC hardware, or WSL must be called out when the current machine cannot exercise it.
