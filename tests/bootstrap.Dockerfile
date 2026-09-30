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

# Exercise regular-file backup behavior and the forced cutover from a foreign
# inputrc symlink. Empty mise only inside the image to avoid unrelated CLIs.
RUN printf 'pre-existing git config\n' > "$HOME/.gitconfig" \
    && printf 'legacy inputrc\n' > "$HOME/legacy-inputrc" \
    && ln -s "$HOME/legacy-inputrc" "$HOME/.inputrc" \
    && printf '[tools]\n' > config/mise/config.toml
RUN ./bootstrap work-wsl --check
RUN ./bootstrap work-wsl

RUN test -L "$HOME/.gitconfig" \
    && test -L "$HOME/.config/btop" \
    && test -L "$HOME/.config/gh/config.yml" \
    && test -L "$HOME/.config/opencode/opencode.json" \
    && mapfile -t backups < <(compgen -G "$HOME/.gitconfig.hm-backup-*") \
    && test "$(readlink -e "$HOME/.inputrc")" = "$HOME/dotfiles/config/shell/inputrc" \
    && grep -qx 'legacy inputrc' "$HOME/legacy-inputrc" \
    && (( ${#backups[@]} == 1 )) \
    && grep -qx 'pre-existing git config' "${backups[0]}"

# A second activation must succeed without creating another collision backup.
RUN ./bootstrap work-wsl \
    && mapfile -t backups < <(compgen -G "$HOME/.gitconfig.hm-backup-*") \
    && (( ${#backups[@]} == 1 ))
