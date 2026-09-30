if type complete >/dev/null 2>&1; then
  _pnpm_completion() {
    local words cword
    if type _get_comp_words_by_ref >/dev/null 2>&1; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword=$COMP_CWORD
      words=("${COMP_WORDS[@]}")
    fi

    local old_ifs=$IFS
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
      COMP_LINE="$COMP_LINE" \
      COMP_POINT="$COMP_POINT" \
      SHELL=bash \
      pnpm completion-server -- "${words[@]}" 2>/dev/null)) || return
    IFS=$old_ifs

    if [[ ${COMPREPLY[*]:-} == __tabtab_complete_files__ ]]; then
      COMPREPLY=($(compgen -f -- "$cword"))
    fi
    type __ltrim_colon_completions >/dev/null 2>&1 && __ltrim_colon_completions "${words[cword]}"
  }
  complete -o default -F _pnpm_completion pnpm
fi
