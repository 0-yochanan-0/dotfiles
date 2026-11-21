;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;(setq doom-font (font-spec :family "Intel One Mono" :size 12))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
;;
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)
;;
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
;;
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;;(setq org-directory "~/org/")
;;
;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; =============================================================================
;; UI: Menu Bar, Tool Bar & Frame Defaults
;; Re-enable menu and tool bars for initial and client frames.
;; =============================================================================

(add-hook 'doom-after-init-hook
          (lambda ()
            (menu-bar-mode 1)
            (tool-bar-mode 1)))

(add-to-list 'default-frame-alist '(menu-bar-lines . 1))
(add-to-list 'default-frame-alist '(tool-bar-lines . 1))

;; =============================================================================
;; Platform: OS-Specific UI, Paths & Rendering Tweaks
;; Keep macOS GUI paths (TeX) and Linux/macOS frame rendering consistent.
;; =============================================================================

(cond (IS-MAC
       (add-to-list 'default-frame-alist '(inhibit-double-buffering . t))
       (setq ns-use-native-fullscreen nil
             frame-inhibit-implied-resize t
             inhibit-compacting-font-caches t)
       (add-to-list 'exec-path "/Library/TeX/texbin")
       (setenv "PATH" (concat "/Library/TeX/texbin:" (getenv "PATH"))))
      (IS-LINUX
       (setq frame-inhibit-implied-resize t)))

;; =============================================================================
;; UI: Dashboard & Quick File Creation
;; Replace Org Agenda on the splash screen and bind SPC f n to find-file.
;; =============================================================================

(setq +dashboard-menu-sections
      (mapcar
       (lambda (item)
         (if (equal (car item) "Open org-agenda")
             '("New file"
               :icon (nerd-icons-mdicon
                      "nf-md-file_plus"
                      :face '+dashboard-menu-title)
               :key "SPC f n"
               :action find-file)
           item))
       +dashboard-menu-sections))

(map! :leader
      :desc "New file"
      "f n" #'find-file)

;; =============================================================================
;; Core: Emacs Server
;; Start the background server so emacsclient frames connect immediately.
;; =============================================================================

(add-hook 'doom-after-init-hook
          (lambda ()
            (require 'server)
            (unless (server-running-p)
              (server-start))))

;; =============================================================================
;; Media: Radio Player (eradio)
;; Configure mpv streaming backend, station presets, and SPC r keybindings.
;; =============================================================================

(after! eradio
  (setq eradio-player '("mpv" "--no-video" "--no-terminal")
        eradio-channels '(("Sonic Universe"         . "https://ice2.somafm.com/sonicuniverse-128-aac")
                          ("Space Station"          . "https://ice6.somafm.com/spacestation-128-aac")
                          ("Lush"                   . "https://ice2.somafm.com/lush-128-aac")
                          ("Illinois Street Lounge" . "https://ice2.somafm.com/illstreet-128-aac")
                          ("Deep Space One"         . "https://ice2.somafm.com/deepspaceone-128-aac")
                          ("Heavyweight Reggae"     . "https://ice2.somafm.com/reggae-128-aac")
                          ("Folk Forward"           . "https://ice6.somafm.com/folkfwd-128-aac")
                          ("DEF CON"                . "https://ice6.somafm.com/defcon-128-aac")
                          ("Radio NÖ"               . "https://orf-live.ors-shoutcast.at/noe-q2a")
                          ("CRo Dvojka"             . "https://rozhlas.stream/dvojka_high.aac")
                          ("CRo Sport"              . "https://rozhlas.stream/radiozurnal_sport_high.aac")
                          ("CRo Jazz"               . "https://rozhlas.stream/jazz_high.aac")
                          ("CRo D-Dur"              . "https://rozhlas.stream/ddur_high.aac")
                          ("BBC Scotland"           . "http://as-hls-ww-live.akamaized.net/pool_904/live/ww/bbc_radio_scotland_fm/bbc_radio_scotland_fm.isml/bbc_radio_scotland_fm-audio%3d96000.norewind.m3u8")
                          ("BBC Shetland"           . "http://as-hls-ww-live.akamaized.net/pool_23386112/live/ww/bbc_radio_shetland/bbc_radio_shetland.isml/bbc_radio_shetland-audio%3d320000.norewind.m3u8")
                          ("Totally 80s FM"         . "https://zeno.fm/radio/totally-80s-fm/")
                          ("Oldies Radio 50s-60s"   . "https://zeno.fm/radio/oldies-radio-50s-60s/")
                          ("Oldies Radio 70s"       . "https://zeno.fm/radio/oldies-radio-70s/")
                          ("Unlimited 80s"          . "https://zeno.fm/radio/unlimited80s/")
                          ("80s Hits"               . "https://zeno.fm/radio/80shits/")
                          ("90s Hits"               . "https://zeno.fm/radio/90s_HITS/")
                          ("2000s Pop"              . "https://zeno.fm/radio/2000s-pop/")
                          ("The 2000s"              . "https://zeno.fm/radio/the-2000s/")
                          ("Hits 2010s"             . "https://zeno.fm/radio/helia-hits-2010/")
                          ("Classical Radio"        . "https://zeno.fm/radio/classical-radio/")
                          ("Classical Relaxation"   . "https://zeno.fm/radio/radio-christmas-non-stop-classical/")
                          ("Classic Rock"           . "https://zeno.fm/radio/classic-rockdnb2sav8qs8uv/")
                          ("Gangsta49"              . "https://zeno.fm/radio/gangsta49/")
                          ("HipHop49"               . "https://zeno.fm/radio/hiphop49/")
                          ("Madhouse Country Radio" . "https://zeno.fm/radio/madhouse-country-radio/")
                          ("PopMusic"               . "https://zeno.fm/radio/popmusic74vyurvmug0uv/")
                          ("PopStars"               . "https://zeno.fm/radio/popstars/")
                          ("RadioMetal"             . "https://zeno.fm/radio/radio-metal/")
                          ("RocknRoll Radio"        . "https://zeno.fm/radio/rocknroll-radio994c7517qs8uv/"))))

(map! :leader
      (:prefix ("r" . "radio")
       :desc "Play channel"   "p" #'eradio-play
       :desc "Stop player"    "s" #'eradio-stop
       :desc "Toggle player"  "t" #'eradio-toggle))

;; =============================================================================
;; LaTeX: AUCTeX, Prettify Symbols & Auto-Formatting
;; Use LuaTeX + PDF output, refresh symbol glyphs, and format on save/compile.
;; =============================================================================

(after! latex
  ;; 1. Engine & PDF output
  (setq-hook! 'LaTeX-mode-hook TeX-engine 'luatex)
  (setq-hook! 'LaTeX-mode-hook TeX-PDF-mode t)

  ;; 2. Prettify symbols (refresh via font-lock for Emacs 31+ compatibility)
  (setq prettify-symbols-unprettify-at-point nil)
  (add-hook 'LaTeX-mode-hook #'prettify-symbols-mode)

  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq-local prettify-symbols-alist
                          (append prettify-symbols-alist
                                  '(("\\begin{tasks}" . ?↵)
                                    ("\\end{tasks}"   . ?⏎))))
              (add-hook 'after-save-hook #'my/latex-reprettify-buffer nil t)))

  (defun my/latex-reprettify-buffer (&rest _)
    "Refresh `prettify-symbols-mode' across the current LaTeX buffer."
    (when (and (derived-mode-p 'latex-mode 'LaTeX-mode)
               prettify-symbols-mode)
      (font-lock-flush)
      (font-lock-ensure)))

  (advice-add 'yank :after #'my/latex-reprettify-buffer)
  (advice-add 'yank-pop :after #'my/latex-reprettify-buffer)
  (when (fboundp 'evil-paste-after)
    (advice-add 'evil-paste-after :after #'my/latex-reprettify-buffer))
  (when (fboundp 'evil-paste-before)
    (advice-add 'evil-paste-before :after #'my/latex-reprettify-buffer))

  ;; 3. Format buffer automatically before PDF compilation
  (defun my/latex-format-before-compile (&rest _)
    "Format the LaTeX buffer before compiling to PDF."
    (when (and (derived-mode-p 'latex-mode 'LaTeX-mode)
               (fboundp '+format/buffer))
      (+format/buffer)))

  (advice-add 'TeX-command-master :before #'my/latex-format-before-compile)
  (advice-add 'TeX-command-run-all :before #'my/latex-format-before-compile))

;; 4. Format automatically on save via Apheleia (latexindent)
(after! apheleia
  (setf (alist-get 'latexindent apheleia-formatters)
        '("latexindent" "-g" "/dev/null" "-"))
  (setf (alist-get 'LaTeX-mode apheleia-mode-alist) 'latexindent)
  (setf (alist-get 'latex-mode apheleia-mode-alist) 'latexindent))

(add-hook 'LaTeX-mode-hook #'apheleia-mode)

;; =============================================================================
;; Lang: Julia (Eglot)
;; Point eglot-jl at the active Julia environment (update path on upgrades).
;; =============================================================================

(after! eglot-jl
  (setq eglot-jl-language-server-project
        (expand-file-name "~/.julia/environments/v1.12")))

;; =============================================================================
;; Lang: Modern Fortran (fortls via Eglot)
;; Configure fortls language server flags for f90-mode and fortran-mode.
;; =============================================================================

(after! eglot
  (add-to-list 'eglot-server-programs
               '((f90-mode fortran-mode) . ("fortls"
                                            "--allow_modern_comments"
                                            "--enable_fill_empty"
                                            "--autocomplete_no_prefix"))))

;; =============================================================================
;; Lang: ESS / R
;; Set RStudio indentation style, 2-space offset, and default lintr settings.
;; =============================================================================

(after! ess-r-mode
  (setq ess-indent-offset 2
        ess-style 'RStudio
        ess-r-lintr-linters '("default")))

;; =============================================================================
;; Prose: Spellcheck & Language Detection (Hunspell + guess-language)
;; Default to de_AT with en_AU-large support and OS-specific dictionary paths.
;; =============================================================================

(after! ispell
  (setq ispell-dictionary "de_AT")
  (cond (IS-MAC
         (setenv "DICPATH" (concat (getenv "HOME") "/Library/Spelling")))
        (IS-LINUX
         (setenv "DICPATH" "/usr/share/hunspell")))
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "de_AT,en_AU-large"))

(use-package! guess-language
  :defer t
  :init
  (add-hook 'text-mode-hook #'guess-language-mode)
  :config
  (setq guess-language-languages '(de en)
        guess-language-langcodes '((de . ("de_AT" "German"))
                                   (en . ("en_AU-large" "English")))))

(map! :leader
      :desc "Switch dictionary" "t d" #'ispell-change-dictionary)

;; =============================================================================
;; Prose: Grammar Checking (LanguageTool)
;; Sync LanguageTool locale (de-AT vs. en-AU) with the active spell dictionary.
;; =============================================================================

(defun my/langtool-pick-language (&rest _)
  "Set `langtool-default-language' from `ispell-local-dictionary'."
  (setq langtool-default-language
        (if (string-prefix-p "en" (or (bound-and-true-p ispell-local-dictionary) ""))
            "en-AU"
          "de-AT")))

(after! langtool
  (setq langtool-default-language "de-AT")
  (advice-add 'langtool-check :before #'my/langtool-pick-language))
