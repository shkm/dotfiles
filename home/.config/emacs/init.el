;;; init.el --- Emacs configuration -*- lexical-binding: t; -*-

;; Started from emacs-bedrock (https://codeberg.org/ashton314/emacs-bedrock).

;;; Contents:
;;;
;;;  - Packages
;;;  - Defaults
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

(setopt display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)

;; Discoverability for the leader key below. Built in since Emacs 30.
(setopt which-key-idle-delay 0.0)       ; nvim: delay = 0
(which-key-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Theme
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Built-in modus themes, following the macOS appearance the way nvim does.
(load-theme (if (string= "on" (string-trim (shell-command-to-string "dark-mode status")))
                'modus-vivendi
              'modus-operandi)
            :no-confirm)

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
  "Find a file in the dotfiles repo.
Git tracks the dotfiles themselves, so `project-find-file' lists them
without needing nvim's `hidden = true'."
  (interactive)
  (let ((default-directory "~/dotfiles/"))
    (project-find-file)))

(defun my-find-emacs-config ()
  "Find a file in the emacs configuration."
  (interactive)
  (let ((default-directory user-emacs-directory))
    (call-interactively #'find-file)))

(keymap-set my-leader-map "<tab>" #'evil-switch-to-windows-last-buffer)
(keymap-set my-leader-map "/" #'project-find-regexp)

(keymap-set my-leader-map "f f" #'project-find-file)
(keymap-set my-leader-map "f F" #'find-file)
(keymap-set my-leader-map "f b" #'switch-to-buffer)
(keymap-set my-leader-map "f ." #'recentf-open)
(keymap-set my-leader-map "f p" #'project-switch-project)
(keymap-set my-leader-map "f d" #'my-find-dotfile)
(keymap-set my-leader-map "f e" #'my-find-emacs-config)

(keymap-set my-leader-map "b d" #'kill-current-buffer)

(which-key-add-keymap-based-replacements my-leader-map
  "f" "find"
  "b" "buffer")

(setq gc-cons-threshold my-initial-gc-threshold)

;;; init.el ends here
