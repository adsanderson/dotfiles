{ ... }:
{
  home.sessionVariables = {
    DOTFILES_PROFILE = "work-wsl";
  };

  programs.bash.initExtra = ''
    if command -v wslview >/dev/null 2>&1; then
      export BROWSER=wslview
    fi
  '';
}
