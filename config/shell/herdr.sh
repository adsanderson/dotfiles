_herdr_ratio() {
  awk -v a="$1" -v b="$2" 'BEGIN { printf "%.4f", a / b }'
}

_herdr_split() {
  herdr pane split "$1" --direction "$2" --ratio "$3" --cwd "$4" --no-focus |
    jq -r '.result.pane.pane_id'
}

hdl() {
  [[ -n ${1:-} ]] || { printf 'Usage: hdl <ai-command> [second-ai-command]\n' >&2; return 1; }
  [[ -n ${HERDR_PANE_ID:-} ]] || { printf 'hdl must run inside Herdr\n' >&2; return 1; }
  local current_dir=$PWD editor_pane=$HERDR_PANE_ID ai_pane ai2_pane ai=$1 ai2=${2:-}
  herdr tab rename "$HERDR_TAB_ID" "$(basename "$current_dir")" >/dev/null
  _herdr_split "$editor_pane" down 0.85 "$current_dir" >/dev/null
  ai_pane=$(_herdr_split "$editor_pane" right 0.7 "$current_dir")
  if [[ -n $ai2 ]]; then
    ai2_pane=$(_herdr_split "$ai_pane" down 0.5 "$current_dir")
    herdr pane run "$ai2_pane" "$ai2" >/dev/null
  fi
  herdr pane run "$ai_pane" "$ai" >/dev/null
  herdr pane run "$editor_pane" "$EDITOR ." >/dev/null
}

hds() {
  (( $# == 0 )) || { printf 'Usage: hds\n' >&2; return 1; }
  [[ -n ${HERDR_PANE_ID:-} ]] || { printf 'hds must run inside Herdr\n' >&2; return 1; }
  local current_dir=$PWD editor_pane=$HERDR_PANE_ID terminal_pane diff_pane ai_pane
  herdr tab rename "$HERDR_TAB_ID" "$(basename "$current_dir")" >/dev/null
  terminal_pane=$(_herdr_split "$editor_pane" down 0.5 "$current_dir")
  diff_pane=$(_herdr_split "$editor_pane" right 0.5 "$current_dir")
  ai_pane=$(_herdr_split "$terminal_pane" right 0.5 "$current_dir")
  herdr pane run "$editor_pane" 'nvim .' >/dev/null
  herdr pane run "$diff_pane" 'hunk diff --watch' >/dev/null
  herdr pane run "$ai_pane" opencode >/dev/null
}

hdlm() {
  [[ -n ${1:-} ]] || { printf 'Usage: hdlm <ai-command> [second-ai-command]\n' >&2; return 1; }
  [[ -n ${HERDR_PANE_ID:-} ]] || { printf 'hdlm must run inside Herdr\n' >&2; return 1; }
  local ai=$1 ai2=${2:-} base_dir=$PWD first=true dir dirpath pane_id command
  herdr workspace rename "$HERDR_WORKSPACE_ID" "$(basename "$base_dir")" >/dev/null
  for dir in "$base_dir"/*/; do
    [[ -d $dir ]] || continue
    dirpath=${dir%/}
    printf -v command 'hdl %q' "$ai"
    [[ -n $ai2 ]] && printf -v command '%s %q' "$command" "$ai2"
    if $first; then
      printf -v command 'cd %q && %s' "$dirpath" "$command"
      herdr pane run "$HERDR_PANE_ID" "$command" >/dev/null
      first=false
    else
      pane_id=$(herdr tab create --workspace "$HERDR_WORKSPACE_ID" --cwd "$dirpath" --no-focus |
        jq -r '.result.root_pane.pane_id')
      herdr pane run "$pane_id" "$command" >/dev/null
    fi
  done
}

hsl() {
  (( $# == 2 )) || { printf 'Usage: hsl <pane-count> <command>\n' >&2; return 1; }
  [[ -n ${HERDR_PANE_ID:-} ]] || { printf 'hsl must run inside Herdr\n' >&2; return 1; }
  local count=$1 cmd=$2 current_dir=$PWD cols=1 k index rows j col last pane
  local -a columns panes
  herdr tab rename "$HERDR_TAB_ID" "$(basename "$current_dir")" >/dev/null
  while (( cols * cols < count )); do ((cols++)); done
  columns=("$HERDR_PANE_ID")
  for (( k = 1; k < cols; k++ )); do
    columns+=("$(_herdr_split "${columns[-1]}" right "$(_herdr_ratio 1 $((cols - k + 1)))" "$current_dir")")
  done
  for (( index = 0; index < cols; index++ )); do
    col=${columns[index]}
    rows=$(( count / cols ))
    (( index < count % cols )) && ((rows++))
    panes+=("$col")
    last=$col
    for (( j = 1; j < rows; j++ )); do
      last=$(_herdr_split "$last" down "$(_herdr_ratio 1 $((rows - j + 1)))" "$current_dir")
      panes+=("$last")
    done
  done
  for pane in "${panes[@]}"; do
    herdr pane run "$pane" "$cmd" >/dev/null
  done
}
