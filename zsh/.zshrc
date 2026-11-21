# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Initialize Homebrew environment early so paths and tools (like xcrun/gcc) are available
eval "$(/opt/homebrew/bin/brew shellenv)"

# Path to your Oh My Zsh installation and binary paths
# Oh My Zsh Directory
export ZSH="$HOME/.oh-my-zsh"

# Consolidated PATH (User bins, custom apps, Homebrew, and keg-only paths)
export PATH="$HOME/.local/bin:$HOME/.config/emacs/bin:$HOME/.cargo/bin:/opt/homebrew/opt/cups/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/Applications/WezTerm.app/Contents/MacOS:$PATH"
#eval "$(register-python-argcomplete pipx)"


# GCC-16 & Native Compilation environment configuration
export CC="gcc-16"
export CXX="g++-16"
export LIBGCCJIT_BINARY="/opt/homebrew/bin/gcc-16"
export LIBRARY_PATH="/opt/homebrew/opt/gcc/lib/gcc/16:/opt/homebrew/lib"
export CPATH="$(xcrun --show-sdk-path)"
export C_INCLUDE_PATH="$(xcrun --show-sdk-path)/usr/include"

# Set name of the theme to load
#ZSH_THEME="powerlevel10k/powerlevel10k"

# Initialize completion system once
#autoload -Uz compinit && compinit

# Which plugins would you like to load?
plugins=(git zsh-autosuggestions zsh-completions zsh-history-substring-search fast-syntax-highlighting)
#plugins=(git zsh-autosuggestions zsh-completions zsh-history-substring-search zsh-syntax-highlighting fast-syntax-highlighting)

# Source custom plugin scripts
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/oh-my-zsh.sh

# mc faster start in zsh, but no subshell
alias mc="SHELL=/bin/bash mc"
# ---- Eza (better ls) -----
#alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ls='eza --color=always --long --group-directories-first --icons'
alias lt='eza -aT --color=always --long --group-directories-first --icons'  # tree view
# Safety nets
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'         # asks before deleting
# Better cat with syntax highlighting
alias cat='bat'
# Open in terminal
# Path to the emacsclient inside your Emacs Plus Cask
export EMACS_CLIENT="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
# Alias for instant GUI window
alias ec="$EMACS_CLIENT -c -n"
# Alias for terminal mode
alias et="$EMACS_CLIENT -t"

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
#

# Load Powerlevel10k theme and configurations
source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
