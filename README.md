# My Dotfiles

Personal configuration files for Linux/macOS environments (primarily Arch/CachyOS), built around a consistent **Gruvbox** palette and a template-driven workflow without relying on heavy upstream configuration frameworks.

## Current Status

* **Doom Emacs** — Active; configured for daily editing, technical writing, and **LaTeX** workflows.
* **Kitty** — Active; terminal styling and color scheme configuration.
* **Zsh** — Active; shell environment, aliases, and prompt setup.
* **Hyprland / Waybar** — *Work in progress*; decoupling layouts from theme palettes and moving toward Jinja2 template compilation and hard-copy deployment.

## Design Goals

* **Unified Gruvbox Theming:** Keep colors consistent across terminal, editor, shell, and desktop components using semantic palette tokens and templates rather than scattered hardcoded hex values.
* **Emacs & LaTeX Optimization:** Tune Doom Emacs for responsive editing, clean LaTeX compilation/previewing, and multi-language technical and prose workflows.
* **Clean Deployment Boundaries:** Keep source configurations and templates in Git while deploying independent configuration files to target paths so local runtime changes do not pollute the repository.

## Repository Layout

```text
.
├── README.md
├── doom/        # Doom Emacs configuration (init.el, config.el, packages.el)
├── kitty/       # Kitty terminal configuration
├── zsh/         # Zsh shell configuration
└── ...          # Additional modules/templates as they mature
