#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/.dotfiles"
ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH_DIR/custom}"

echo "==> Detecting operating system..."
if [[ "$OSTYPE" == darwin* ]]; then
  OS="macos"
elif [[ "$OSTYPE" == linux* ]]; then
  OS="linux"
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi

# ==============================================================================
# 1. System Packages (Homebrew on macOS / Pacman on CachyOS)
# ==============================================================================

if [[ "$OS" == "macos" ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi

  echo "==> Installing Homebrew formulae..."
  brew install \
    git stow ripgrep fd \
    eza bat fzf mc btop \
    zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search \
    hunspell languagetool lua-language-server stylua

  echo "==> Installing Homebrew casks..."
  brew install --cask \
    kitty \
    font-meslo-lg-nerd-font \
    mactex-no-gui

  if [[ ! -d "/Applications/Emacs.app" ]]; then
    brew tap d12frosted/emacs-plus
    brew install emacs-plus@30 --with-native-comp --with-dbus
    ln -sfn "$(brew --prefix)/opt/emacs-plus@30/Emacs.app" /Applications/Emacs.app
  fi

elif [[ "$OS" == "linux" ]]; then
  PRIV_CMD="doas"
  command -v doas >/dev/null 2>&1 || PRIV_CMD="sudo"

  echo "==> Installing Pacman packages..."
  $PRIV_CMD pacman -Syu --needed --noconfirm \
    git stow ripgrep fd base-devel \
    kitty ttf-meslo-nerd \
    eza bat fzf mc btop \
    zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search \
    emacs-wayland hunspell hunspell-de hunspell-en_au languagetool \
    texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra \
    texlive-luatex texlive-langgerman texlive-binextra \
    lua-language-server stylua

  # Install zsh-autocomplete via AUR helper (paru/yay) if available, else fallback to OMZ custom
  if command -v paru >/dev/null 2>&1; then
    paru -S --needed --noconfirm zsh-autocomplete
  elif command -v yay >/dev/null 2>&1; then
    yay -S --needed --noconfirm zsh-autocomplete
  fi
fi

# ==============================================================================
# 2. Oh My Zsh & Powerlevel10k
# ==============================================================================

if [[ ! -d "$ZSH_DIR" ]]; then
  echo "==> Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]]; then
  echo "==> Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Fallback clone for zsh-autocomplete if neither Homebrew nor /usr/share provided it
if [[ ! -r "/opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]] && \
   [[ ! -r "/usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]] && \
   [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autocomplete" ]]; then
  echo "==> Cloning zsh-autocomplete into ZSH_CUSTOM..."
  git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete.git "$ZSH_CUSTOM/plugins/zsh-autocomplete"
fi

# ==============================================================================
# 3. Backup Conflicts & Deploy Stow Symlinks
# ==============================================================================

echo "==> Deploying dotfiles via Stow..."
mkdir -p "$HOME/.config"
for target in "$HOME/.zshrc" "$HOME/.config/doom" "$HOME/.config/kitty"; do
  if [[ -e "$target" && ! -L "$target" ]]; then
    mv "$target" "${target}.bak.$(date +%Y%m%d%H%M%S)"
  fi
done

cd "$DOTFILES_DIR"
stow -R doom kitty zsh

# ==============================================================================
# 4. Doom Emacs Installation / Sync
# ==============================================================================

if [[ ! -d "$HOME/.config/emacs" ]]; then
  echo "==> Installing Doom Emacs..."
  git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
  "$HOME/.config/emacs/bin/doom" install --no-env --no-fonts
else
  echo "==> Syncing Doom Emacs..."
  "$HOME/.config/emacs/bin/doom" sync
fi

echo "==> Done! Restart your terminal or run: exec zsh"
