# -----------------------------
# FZF-TAB Optimized Settings
# -----------------------------

# Show a preview for files using bat
zstyle ':fzf-tab:*' fzf-preview '[[ -f $realpath ]] && bat --style=numbers --color=always $realpath || ls --color=always $realpath'

# Use inline previews (fzf 0.35+ required)
zstyle ':fzf-tab:*' show-group go

# Switch groups with Tab / Shift-Tab
zstyle ':fzf-tab:*' switch-group ',' '.'

# Better completion style
zstyle ':fzf-tab:*' prefix ''

# Enable directory previews using exa if present
if command -v exa >/dev/null; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -T --color=always $realpath'
fi
