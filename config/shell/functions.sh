compress() {
  (( $# == 1 )) || { printf 'Usage: compress <path>\n' >&2; return 1; }
  tar -czf "${1%/}.tar.gz" "${1%/}"
}

decompress() {
  (( $# == 1 )) || { printf 'Usage: decompress <archive.tar.gz>\n' >&2; return 1; }
  tar -xzf "$1"
}

open() {
  command -v xdg-open >/dev/null 2>&1 || return 127
  (xdg-open "$@" >/dev/null 2>&1 &)
}

sff() {
  (( $# == 1 )) || { printf 'Usage: sff <host:/destination>\n' >&2; return 1; }
  local file
  file=$(find . -type f -printf '%T@\t%p\n' | sort -rn | cut -f2- | ff) || return
  [[ -n $file ]] && scp "$file" "$1"
}

fip() {
  (( $# >= 2 )) || { printf 'Usage: fip <host> <port> [port...]\n' >&2; return 1; }
  local host=$1 port
  shift
  for port in "$@"; do
    ssh -f -N -L "${port}:localhost:${port}" "$host" || return
    printf 'Forwarding localhost:%s -> %s:%s\n' "$port" "$host" "$port"
  done
}

dip() {
  (( $# > 0 )) || { printf 'Usage: dip <port> [port...]\n' >&2; return 1; }
  local port
  for port in "$@"; do
    pkill -f "ssh.*-L ${port}:localhost:${port}" \
      && printf 'Stopped forwarding port %s\n' "$port" \
      || printf 'No forwarding on port %s\n' "$port"
  done
}

lip() {
  pgrep -af 'ssh.*-L [0-9]+:localhost:[0-9]+' || printf 'No active forwards\n'
}

ga() {
  [[ -n ${1:-} ]] || { printf 'Usage: ga <branch>\n' >&2; return 1; }
  local branch=$1 base wt_path
  base=$(basename "$PWD")
  wt_path="../${base}--${branch}"
  git worktree add -b "$branch" "$wt_path" || return
  command -v mise >/dev/null 2>&1 && mise trust "$wt_path"
  cd "$wt_path" || return
}

gd() {
  command -v gum >/dev/null 2>&1 || { printf 'gd requires gum\n' >&2; return 127; }
  gum confirm 'Remove worktree and branch?' || return
  local cwd worktree root branch
  cwd=$PWD
  worktree=$(basename "$cwd")
  root=${worktree%%--*}
  branch=${worktree#*--}
  [[ $root != "$worktree" ]] || { printf 'Not in a name--branch worktree\n' >&2; return 1; }
  cd "../$root" || return
  git worktree remove "$cwd" --force && git branch -D "$branch"
}

tdl() {
  [[ -n ${1:-} ]] || { printf 'Usage: tdl <ai-command> [second-ai-command]\n' >&2; return 1; }
  [[ -n ${TMUX:-} ]] || { printf 'tdl must run inside tmux\n' >&2; return 1; }
  local current_dir=$PWD editor_pane=$TMUX_PANE ai_pane ai2_pane ai=$1 ai2=${2:-}
  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"
  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" -l "$ai2"
    tmux send-keys -t "$ai2_pane" C-m
  fi
  tmux send-keys -t "$ai_pane" -l "$ai"
  tmux send-keys -t "$ai_pane" C-m
  tmux send-keys -t "$editor_pane" -l "$EDITOR ."
  tmux send-keys -t "$editor_pane" C-m
  tmux select-pane -t "$editor_pane"
}

tds() {
  (( $# == 0 )) || { printf 'Usage: tds\n' >&2; return 1; }
  [[ -n ${TMUX:-} ]] || { printf 'tds must run inside tmux\n' >&2; return 1; }
  local current_dir=$PWD editor_pane=$TMUX_PANE terminal_pane diff_pane ai_pane
  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"
  terminal_pane=$(tmux split-window -v -p 50 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
  diff_pane=$(tmux split-window -h -p 50 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
  ai_pane=$(tmux split-window -h -p 50 -t "$terminal_pane" -c "$current_dir" -P -F '#{pane_id}')
  tmux send-keys -t "$editor_pane" -l 'nvim .'; tmux send-keys -t "$editor_pane" C-m
  tmux send-keys -t "$diff_pane" -l 'hunk diff --watch'; tmux send-keys -t "$diff_pane" C-m
  tmux send-keys -t "$ai_pane" -l 'opencode'; tmux send-keys -t "$ai_pane" C-m
  tmux select-pane -t "$editor_pane"
}

tdlm() {
  [[ -n ${1:-} ]] || { printf 'Usage: tdlm <ai-command> [second-ai-command]\n' >&2; return 1; }
  [[ -n ${TMUX:-} ]] || { printf 'tdlm must run inside tmux\n' >&2; return 1; }
  local ai=$1 ai2=${2:-} base_dir=$PWD first=true dir dirpath pane_id command
  tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"
  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    dirpath=${dir%/}
    printf -v command 'tdl %q' "$ai"
    [[ -n $ai2 ]] && printf -v command '%s %q' "$command" "$ai2"
    if $first; then
      printf -v command 'cd %q && %s' "$dirpath" "$command"
      tmux send-keys -t "$TMUX_PANE" -l "$command"
      tmux send-keys -t "$TMUX_PANE" C-m
      first=false
    else
      pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
      tmux send-keys -t "$pane_id" -l "$command"
      tmux send-keys -t "$pane_id" C-m
    fi
  done
}

tsl() {
  (( $# == 2 )) || { printf 'Usage: tsl <pane-count> <command>\n' >&2; return 1; }
  [[ -n ${TMUX:-} ]] || { printf 'tsl must run inside tmux\n' >&2; return 1; }
  local count=$1 cmd=$2 current_dir=$PWD new_pane split_target pane
  local -a panes=("$TMUX_PANE")
  tmux rename-window -t "$TMUX_PANE" "$(basename "$current_dir")"
  while (( ${#panes[@]} < count )); do
    split_target=${panes[-1]}
    new_pane=$(tmux split-window -h -t "$split_target" -c "$current_dir" -P -F '#{pane_id}')
    panes+=("$new_pane")
    tmux select-layout -t "${panes[0]}" tiled
  done
  for pane in "${panes[@]}"; do
    tmux send-keys -t "$pane" -l "$cmd"
    tmux send-keys -t "$pane" C-m
  done
  tmux select-pane -t "${panes[0]}"
}
