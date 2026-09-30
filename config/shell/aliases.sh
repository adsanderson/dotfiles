if command -v eza >/dev/null 2>&1; then
  alias ls='eza -lh --group-directories-first --icons=auto'
  alias lsa='ls -a'
  alias lt='eza --tree --level=2 --long --icons --git'
  alias lta='lt -a'
fi

if command -v fzf >/dev/null 2>&1 && command -v bat >/dev/null 2>&1; then
  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
  alias eff='$EDITOR "$(ff)"'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
alias t='tmux attach || tmux new -s Work'
alias c='opencode --auto'
alias cx='printf "\033[2J\033[3J\033[H" && claude --permission-mode auto'
alias cy='codex --approve-for-me'
alias mup='MISE_MINIMUM_RELEASE_AGE=0 mise up'
if command -v herdr >/dev/null 2>&1; then
  alias h='herdr'
fi
alias ic='tdl c'
alias ix='tdl cx'
alias icx='tdl c cx'

n() {
  if (( $# == 0 )); then
    command nvim .
  else
    command nvim "$@"
  fi
}

if command -v zoxide >/dev/null 2>&1; then
  alias cd='zd'
  zd() {
    if (( $# == 0 )); then
      builtin cd ~ || return
    elif [[ -d $1 ]]; then
      builtin cd "$1" || return
    elif z "$@"; then
      printf '󱞩 %s\n' "$PWD"
    else
      printf 'Directory not found\n' >&2
      return 1
    fi
  }
fi
