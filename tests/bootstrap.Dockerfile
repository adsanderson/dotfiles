FROM archlinux:base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN pacman -Syu --noconfirm --needed curl git xz \
    && pacman -Scc --noconfirm

RUN useradd --create-home --shell /bin/bash adams \
    && mkdir /nix \
    && chown adams:adams /nix

COPY --chown=adams:adams . /home/adams/dotfiles

USER adams
ENV HOME=/home/adams
ENV USER=adams
WORKDIR /home/adams/dotfiles

# Exercise collision backup behavior without installing the optional global mise tools.
RUN printf 'pre-existing git config\n' > "$HOME/.gitconfig" \
    && printf '[tools]\n' > config/mise/config.toml

RUN ./bootstrap work-wsl --check
RUN ./bootstrap work-wsl

RUN test -L "$HOME/.gitconfig" \
    && test -L "$HOME/.config/btop" \
    && test -L "$HOME/.config/gh/config.yml" \
    && test -L "$HOME/.config/opencode/opencode.json" \
    && mapfile -t backups < <(compgen -G "$HOME/.gitconfig.hm-backup-*") \
    && (( ${#backups[@]} == 1 )) \
    && grep -qx 'pre-existing git config' "${backups[0]}"

# A second activation must succeed without creating another collision backup.
RUN ./bootstrap work-wsl \
    && mapfile -t backups < <(compgen -G "$HOME/.gitconfig.hm-backup-*") \
    && (( ${#backups[@]} == 1 ))
