# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
# Platform: OS-Specific Paths & Toolchain Environment
# Configure Homebrew, Apple SDK paths, and Emacs client on macOS vs. Linux.
# ==============================================================================

export ZSH="$HOME/.oh-my-zsh"

if [[ "$OSTYPE" == darwin* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="$HOME/.local/bin:$HOME/.config/emacs/bin:$HOME/.cargo/bin:/opt/homebrew/opt/cups/bin:/Applications/WezTerm.app/Contents/MacOS:$PATH"
    export CC="gcc-16"
    export CXX="g++-16"
    export LIBGCCJIT_BINARY="/opt/homebrew/bin/gcc-16"
    export LIBRARY_PATH="/opt/homebrew/opt/gcc/lib/gcc/16:/opt/homebrew/lib"
    export EMACS_CLIENT="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
else
    export PATH="$HOME/.local/bin:$HOME/.config/emacs/bin:$HOME/.cargo/bin:$PATH"
    export EMACS_CLIENT="emacsclient"
fi


# ==============================================================================
# Shell: Oh My Zsh, Plugins & Prompt Theme
# Load zsh-autocomplete, Oh My Zsh core, extra plugins, and Powerlevel10k
# consistently across macOS (Homebrew) and CachyOS (system/custom paths).
# ==============================================================================

# 1. Helper to source the first existing plugin path
_load_zsh_plugin() {
  local p
  for p in "$@"; do
    if [[ -r "$p" ]]; then
      source "$p"
      return 0
    fi
  done
}

# 2. Load zsh-autocomplete BEFORE oh-my-zsh.sh so it owns compinit
_load_zsh_plugin \
  "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" \
  "/usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh" \
  "$ZSH_CUSTOM/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

# 3. Core Oh My Zsh plugins
plugins=(
  git
  fzf
  extract
  sudo
  colored-man-pages
)

source "$ZSH/oh-my-zsh.sh"

# 4. Load post-OMZ plugins in strict dependency order
_load_zsh_plugin \
  "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

_load_zsh_plugin \
  "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

_load_zsh_plugin \
  "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-history-substring-search/zsh-history-substring-search.zsh" \
  "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" \
  "$ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

unset -f _load_zsh_plugin

# 5. Powerlevel10k prompt theme
_load_p10k() {
  local t
  for t in \
    "${HOMEBREW_PREFIX:-/opt/homebrew}/share/powerlevel10k/powerlevel10k.zsh-theme" \
    "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" \
    "$ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme"; do
    if [[ -r "$t" ]]; then
      source "$t"
      return 0
    fi
  done
}
_load_p10k
unset -f _load_p10k

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ==============================================================================
# Aliases: File Listing, Safety Nets, Editor & Midnight Commander
# Use eza, bat, interactive file safety flags, and emacsclient shortcuts.
# ==============================================================================

# File listing & viewing
alias ls='eza --color=always --group-directories-first --icons=always'
alias ll='eza -la --color=always --group-directories-first --icons=always'
alias lt='eza -aT --color=always --group-directories-first --icons=always'
alias l='eza -l --color=always --group-directories-first --icons=always'
alias cat='bat'

# Navigation & safety nets
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'

# Editors & Midnight Commander
alias ec="$EMACS_CLIENT -c -n"
alias et="$EMACS_CLIENT -t"
alias mc="SHELL=/bin/bash mc"

# Linux / CachyOS / Hyprland specific
if [[ "$OSTYPE" == linux* ]]; then
    command -v doas >/dev/null 2>&1 && alias sudo='doas'
    alias smc='doas env SHELL=/bin/bash mc'
    alias pss='pacman -Ss'
    alias pqi='pacman -Qi'
    alias pql='pacman -Ql'
    alias hreload='hyprctl reload'
    alias hkill='hyprctl kill'
    alias hlogs='cat ~/.cache/hyprland/hyprland.log | tail -50'
    alias music-mode='systemctl --user stop hypridle && notify-send "Music mode" "Screen lock disabled"'
    alias music-stop='systemctl --user start hypridle && notify-send "Music mode" "Screen lock enabled"'
alias sudo='doas'
fi

# ==============================================================================
# Theme: Gruvbox Dark fzf Palette
# Match fzf colors to Gruvbox Dark (#282828 ground, #ebdbb2 fg, #fabd2f accent).
# ==============================================================================

export FZF_DEFAULT_OPTS="
  --color=bg+:#3c3836,bg:#282828,spinner:#fabd2f,hl:#fe8019
  --color=fg:#ebdbb2,header:#83a598,info:#b8bb26,pointer:#fabd2f
  --color=marker:#fb4934,fg+:#fbf1c7,prompt:#fabd2f,hl+:#fb4934"
