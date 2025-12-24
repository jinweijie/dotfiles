########################################
# Optimized Zsh + Zim + fzf integration
########################################

# -----------------------------
# 1) fzf core
# -----------------------------
export FZF_DEFAULT_OPTS="
  --height 50%
  --layout=reverse
  --border
  --inline-info
"

# -----------------------------
# 2) Choose fastest file lister
#    Priority: fd → bfs → find
# -----------------------------
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
elif command -v bfs >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='bfs . -type f -printf "%p\n"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
else
  export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/\.git/*"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# -----------------------------
# 3) Directory search
#    fd/bfs/find for Alt-C
# -----------------------------
if command -v fd >/dev/null 2>&1; then
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif command -v bfs >/dev/null 2>&1; then
  export FZF_ALT_C_COMMAND='bfs . -type d -printf "%p\n"'
else
  export FZF_ALT_C_COMMAND='find . -type d -not -path "*/\.git/*"'
fi

# -----------------------------
# 4) Preview settings
# -----------------------------
if command -v bat >/dev/null 2>&1; then
  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}'"
else
  export FZF_CTRL_T_OPTS="--preview 'head -n 200 {}'"
fi

# Use exa to preview directory trees if installed
if command -v exa >/dev/null 2>&1; then
  export FZF_ALT_C_OPTS="--preview 'exa -T --color=always {}'"
fi

# -----------------------------
# 5) Shell integration (keybindings + completion)
# -----------------------------
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# -----------------------------
# 6) ripgrep + fzf helper functions
# -----------------------------

# fuzzy grep in current directory
fzz() {
  rg --files | fzf --preview 'rg --color=always --line-number {}'
}

# fuzzy search in file contents with ripgrep
fsearch() {
  local query
  query="$(printf "%s" "$1")"
  rg --line-number --no-heading --color=always "$query" | fzf
}

########################################
# End of Optimized Zsh + Zim + fzf config
########################################
