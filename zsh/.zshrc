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
# Load completions, autosuggestions, syntax highlighting, and Powerlevel10k.
# ==============================================================================

plugins=(
  git
  zsh-autosuggestions
  zsh-completions
  zsh-history-substring-search
  fast-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"
source "$ZSH/custom/themes/powerlevel10k/powerlevel10k.zsh-theme"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ==============================================================================
# Aliases: File Listing, Safety Nets, Editor & Midnight Commander
# Use eza, bat, interactive file safety flags, and emacsclient shortcuts.
# ==============================================================================

alias mc="SHELL=/bin/bash mc"
alias ls='eza --color=always --long --group-directories-first --icons'
alias lt='eza -aT --color=always --long --group-directories-first --icons'

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias cat='bat'

alias ec="$EMACS_CLIENT -c -n"
alias et="$EMACS_CLIENT -t"

# ==============================================================================
# Theme: Gruvbox Dark fzf Palette
# Match fzf colors to Gruvbox Dark (#282828 ground, #ebdbb2 fg, #fabd2f accent).
# ==============================================================================

export FZF_DEFAULT_OPTS="
  --color=bg+:#3c3836,bg:#282828,spinner:#fabd2f,hl:#fe8019
  --color=fg:#ebdbb2,header:#83a598,info:#b8bb26,pointer:#fabd2f
  --color=marker:#fb4934,fg+:#fbf1c7,prompt:#fabd2f,hl+:#fb4934"
