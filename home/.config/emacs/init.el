;;; init.el --- Emacs configuration -*- lexical-binding: t; -*-

;; Started from emacs-bedrock (https://codeberg.org/ashton314/emacs-bedrock).

;;; Contents:
;;;
;;;  - Packages
;;;  - Defaults
;;;  - Completion
;;;  - Theme
;;;  - Evil
;;;  - Keys

(when (< emacs-major-version 30)
  (error "This config targets Emacs 30+; this is %s" emacs-version))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Packages
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; evil-collection isn't on the GNU ELPAs.
;;
;; No `package-refresh-contents' here: normal startup uses
;; `package-activate-all', which leaves `package-archive-contents' empty, so
;; guarding on it refreshes over the network every single boot. `use-package
;; :ensure' refreshes on its own when a package is actually missing.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Defaults
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Keep generated files with the rest of the state, out of the dotfiles repo.
(setopt custom-file (expand-file-name "custom.el" my-state-dir))
(setopt backup-directory-alist `(("." . ,(expand-file-name "backup/" my-state-dir))))
(setopt savehist-file (expand-file-name "history" my-state-dir))
(setopt recentf-save-file (expand-file-name "recentf" my-state-dir))
(setopt project-list-file (expand-file-name "projects" my-state-dir))
(when (file-exists-p custom-file)
  (load custom-file))

;; `.#foo' lock files show up as untracked junk in project directories.
(setopt create-lockfiles nil)

(savehist-mode)
(recentf-mode)
(global-auto-revert-mode)               ; reread buffers changed on disk

(setopt indent-tabs-mode nil)           ; nvim: expandtab
(setopt tab-width 2)                    ; nvim: tabstop
(setopt use-short-answers t)            ; y/n instead of yes/no

;; Emacs rings the bell on undefined keys and on C-g, which is constant noise
;; when a leader sequence gets abandoned.
(setopt ring-bell-function #'ignore)

(setopt display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)

;; Discoverability for the leader key below. Built in since Emacs 30.
(setopt which-key-idle-delay 0.0)       ; nvim: delay = 0
(which-key-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Completion
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The picker list itself: candidates narrow as you type.
(use-package vertico
  :ensure t
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t)
  (vertico-count 15))

;; Space-separated matching in any order, so "ini emacs" finds
;; home/.config/emacs/init.el. This is the part that makes it a fuzzy finder.
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  ;; File-name completion still wants prefix matching, so /u/s/b expands.
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Live grep and better buffer/file pickers, feeding results to the minibuffer
;; as you type rather than dumping them in a results buffer.
(use-package consult
  :ensure t
  :bind (("C-x b" . consult-buffer)      ; orig. switch-to-buffer
         ("M-y"   . consult-yank-pop))   ; orig. yank-pop
  :custom
  ;; Type < inside a multi-source picker to limit it to one source, e.g. < f
  ;; in consult-buffer for recent files only.
  (consult-narrow-key "<")
  (consult-async-min-input 2)
  ;; fd hides dotfiles by default, which in this repo means nearly everything —
  ;; home/.config, home/.claude and so on. fd still honours .gitignore.
  (consult-fd-args '("fd" "--full-path --color=never --hidden --exclude .git"))
  :config
  ;; consult-fd and consult-find pass no :state to consult--read, so unlike
  ;; consult-ripgrep and consult-recent-file they have no preview at all.
  ;; Give them the standard file preview.
  (consult-customize consult-fd consult-find :state (consult--file-preview)))

;; Annotations to the right of each candidate: file size and date, buffer mode,
;; command docstring.
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; nerd-icons defaults to "Symbols Nerd Font Mono", which isn't installed here.
;; 0xProto is a full Nerd Font patch, so it already carries the glyphs.
(use-package nerd-icons
  :ensure t
  :custom
  (nerd-icons-font-family "0xProto Nerd Font Mono"))

(use-package nerd-icons-completion
  :ensure t
  :after (marginalia nerd-icons)
  :config
  (nerd-icons-completion-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Theme
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Built-in modus themes, following the macOS appearance the way nvim does.
;; emacs-plus calls a hook when the appearance changes, so this tracks a
;; light/dark switch live. `ns-system-appearance' is unset before the first
;; frame exists and in a terminal, hence the shell fallback.
(defun my-apply-theme (&optional appearance)
  "Load the modus theme matching APPEARANCE, or the current macOS setting."
  (interactive)
  (let ((dark (pcase (or appearance (bound-and-true-p ns-system-appearance))
                ('dark t)
                ('light nil)
                (_ (string= "on" (string-trim
                                  (shell-command-to-string "dark-mode status")))))))
    (mapc #'disable-theme (copy-sequence custom-enabled-themes))
    (load-theme (if dark 'modus-vivendi 'modus-operandi) :no-confirm)))

(my-apply-theme)
(when (boundp 'ns-system-appearance-change-functions)
  (add-hook 'ns-system-appearance-change-functions #'my-apply-theme))

;; The minibuffer, vertico's list and which-key all share the buffer's
;; background, so they don't read as separate surfaces. Give them a dimmed one.
(require 'modus-themes)

(defface my-panel '((t :inherit default))
  "Background for the popups along the bottom of the frame.")

(defun my-restyle-panel (&rest _)
  "Point `my-panel' at the current theme's dim background."
  (set-face-attribute 'my-panel nil
                      :background (modus-themes-get-color-value 'bg-dim)))

(defun my-use-panel-face ()
  (face-remap-add-relative 'default 'my-panel))

(my-restyle-panel)
(add-hook 'enable-theme-functions #'my-restyle-panel)
(add-hook 'minibuffer-setup-hook #'my-use-panel-face)
(add-hook 'which-key-init-buffer-hook #'my-use-panel-face)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Evil
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)       ; required by evil-collection
  (setq evil-want-C-u-scroll t)
  (setq evil-want-Y-yank-to-eol t)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-redo)
  (setq evil-split-window-below t)      ; nvim: splitbelow
  (setq evil-vsplit-window-right t)     ; nvim: splitright
  :config
  (evil-mode 1))

;; Without this, vim keys stop working the moment you land in dired, help,
;; ibuffer or any other special buffer.
(use-package evil-collection
  :ensure t
  :after evil
  :config
  (evil-collection-init))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Keys
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; From nvim's lua/keymaps.lua

;; Swap ; and : — ex commands are frequent, repeat-find-char is not.
(evil-define-key '(normal visual motion) 'global ";" #'evil-ex)
(evil-define-key '(normal visual motion) 'global ":" #'evil-repeat-find-char)

;; 0 goes to the first non-blank character.
(evil-define-key '(normal visual motion) 'global "0" #'evil-first-non-blank)

;; Leave insert state without reaching for Esc.
(keymap-set evil-insert-state-map "M-j" #'evil-normal-state)

;; `-' opens the containing directory, like oil.nvim.
(evil-define-key '(normal motion) 'global "-" #'dired-jump)

;; Move between windows with C-hjkl. Bound only in the normal-ish states, so
;; C-h stays the help prefix while typing.
(evil-define-key '(normal visual motion) 'global (kbd "C-h") #'windmove-left)
(evil-define-key '(normal visual motion) 'global (kbd "C-j") #'windmove-down)
(evil-define-key '(normal visual motion) 'global (kbd "C-k") #'windmove-up)
(evil-define-key '(normal visual motion) 'global (kbd "C-l") #'windmove-right)

;;; Leader

(defvar my-leader-map (make-sparse-keymap)
  "Keymap bound to SPC in evil's normal, visual and motion states.")

(evil-define-key '(normal visual motion) 'global (kbd "SPC") my-leader-map)

(defun my-find-dotfile ()
  "Find a file in the dotfiles repo."
  (interactive)
  (consult-fd "~/dotfiles/"))

(defun my-find-emacs-config ()
  "Find a file in the emacs configuration."
  (interactive)
  (let ((default-directory user-emacs-directory))
    (call-interactively #'find-file)))

;; ESC cancels a pending leader sequence, like nvim. Emacs's own cancel is C-g.
;; A GUI sends the `escape' symbol, a terminal sends the character; bind both.
(keymap-set my-leader-map "<escape>" #'keyboard-quit)
(keymap-set my-leader-map "ESC" #'keyboard-quit)

(keymap-set my-leader-map "<tab>" #'evil-switch-to-windows-last-buffer)
(keymap-set my-leader-map "/" #'consult-ripgrep)

(keymap-set my-leader-map "f f" #'consult-fd)
(keymap-set my-leader-map "f F" #'find-file)
(keymap-set my-leader-map "f b" #'consult-buffer)
(keymap-set my-leader-map "f ." #'consult-recent-file)
(keymap-set my-leader-map "f p" #'project-switch-project)
(keymap-set my-leader-map "f d" #'my-find-dotfile)
(keymap-set my-leader-map "f e" #'my-find-emacs-config)

(keymap-set my-leader-map "b d" #'kill-current-buffer)

(which-key-add-keymap-based-replacements my-leader-map
  "f" "find"
  "b" "buffer")

(setq gc-cons-threshold my-initial-gc-threshold)

;;; init.el ends here
