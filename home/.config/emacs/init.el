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

;; A GUI Emacs launched from the Dock inherits macOS's minimal PATH rather than
;; the shell's, so fd, rg and anything mise manages can't be found. A terminal
;; Emacs already has the right PATH, hence the guard.
(use-package exec-path-from-shell
  :ensure t
  :if (display-graphic-p)
  :config
  (exec-path-from-shell-initialize))

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

;; Left Option stays as Meta; free the right one to type native macOS
;; characters, so Option+- gives – and Option+Shift+- gives —. nvim needs
;; explicit insert-mode bindings for those because a terminal can't.
(setq ns-right-alternate-modifier 'none)

(setopt display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)

;; A wrapped line is marked with a curly arrow in the fringe in a GUI, and with
;; a backslash in the last column in a terminal. Both are worth keeping, but
;; they draw the eye in the theme's foreground colour. Mute them to `shadow',
;; and use a turnstile rather than a backslash, which reads as an escape.
(set-fringe-bitmap-face 'left-curly-arrow 'shadow)
(set-fringe-bitmap-face 'right-curly-arrow 'shadow)

(unless standard-display-table
  (setq standard-display-table (make-display-table)))
(set-display-table-slot standard-display-table 'wrap
                        (make-glyph-code ?↩ 'shadow))

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

;; In-buffer completion popup, the counterpart to blink.cmp. Emacs 31 draws
;; child frames in a terminal as well as a GUI, so this needs no separate
;; terminal package.
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)                        ; pop up while typing, as Zed does
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 1)
  (corfu-cycle t)
  ;; Preselect the prompt rather than the first candidate, so RET stays a
  ;; newline and never silently accepts something. TAB accepts, as in blink.cmp.
  (corfu-preselect 'prompt)
  :bind (:map corfu-map
              ("RET" . nil))
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))               ; blink.cmp: documentation.auto_show

;; Sources the LSP doesn't provide: file paths, and words from open buffers.
(use-package cape
  :ensure t
  :init
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-dabbrev))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Languages
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Emacs has no equivalent of Zed's bundled language servers, so mason supplies
;; them -- the same registry mason.nvim uses. `mason-setup' puts its bin
;; directory on `exec-path' straight away, then runs its body once the registry
;; has been fetched, so nothing here delays startup. `M-x mason-manager' browses
;; and updates what is installed.
(use-package mason
  :ensure t
  :custom
  ;; With the rest of the generated state, not in the dotfiles repo.
  (mason-dir (expand-file-name "mason/" my-state-dir))
  :config
  (mason-setup
   (dolist (pkg '("ruby-lsp" "lua-language-server"))
     (unless (mason-installed-p pkg)
       (ignore-errors (mason-install pkg))))))

;; eglot is the built-in client, and already knows which command each language
;; needs, so this only has to say which modes should start a server.
(use-package eglot
  :ensure nil                           ; built in
  :hook ((ruby-mode ruby-ts-mode lua-mode lua-ts-mode) . eglot-ensure)
  :custom
  ;; Report diagnostics while typing rather than on save, as Zed does.
  (eglot-send-changes-idle-time 0.3)
  ;; The event log costs time and memory, and only matters when debugging a
  ;; misbehaving server.
  (eglot-events-buffer-config '(:size 0 :format full)))

;; Emacs 31 handles tree-sitter without a helper package: each ts mode registers
;; where its own grammar comes from, so it only needs telling to prefer those
;; modes and to fetch a missing grammar rather than asking every time.
;;
;; Grammars are compiled into `user-emacs-directory' by default, which here is a
;; symlink into the dotfiles repo, so send them to the state directory instead.
(defvar my-treesit-dir (expand-file-name "tree-sitter/" my-state-dir)
  "Directory for compiled tree-sitter grammars.")
(make-directory my-treesit-dir t)

(setopt treesit-extra-load-path (list my-treesit-dir))
(setopt treesit-enabled-modes t)        ; ruby-ts-mode over ruby-mode, etc.
(setopt treesit-auto-install-grammar 'always)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Theme
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Flexoki, the same theme the terminal and nvim use.
(defun my-apply-theme (&optional appearance)
  "Load the flexoki theme matching APPEARANCE, or the current macOS setting."
  (interactive)
  (let ((dark (pcase (or appearance (bound-and-true-p ns-system-appearance))
                ('dark t)
                ('light nil)
                (_ (string= "on" (string-trim
                                  (shell-command-to-string "dark-mode status")))))))
    (mapc #'disable-theme (copy-sequence custom-enabled-themes))
    (load-theme (if dark 'flexoki-themes-dark 'flexoki-themes-light) :no-confirm)))

;; emacs-plus calls a hook when the macOS appearance changes, so this tracks a
;; light/dark switch live. `ns-system-appearance' is unset before the first
;; frame exists and in a terminal, hence the shell fallback in `my-apply-theme'.
(use-package flexoki-themes
  :ensure t
  :demand t
  :config
  (my-apply-theme)
  (when (boundp 'ns-system-appearance-change-functions)
    (add-hook 'ns-system-appearance-change-functions #'my-apply-theme)))

;; The minibuffer, vertico's list and which-key all share the buffer's
;; background, so they don't read as separate surfaces. Remapping `default'
;; leaves the rest of its attributes alone, and follows a theme switch for free.
;;
;; flexoki styles `flexoki-themes-faint-bg' but never declares it, so it isn't a
;; usable face until something does. Declaring it here picks up the theme's own
;; value rather than repeating the hex codes.
(defface flexoki-themes-faint-bg nil
  "Dimmed background, set by whichever flexoki variant is loaded.")

(defun my-use-panel-face ()
  (face-remap-add-relative 'default 'flexoki-themes-faint-bg))

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
;;;   Mode line
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; No mode line at all: buffer status goes to the right of the echo area, which
;; sits idle most of the time. Buys back a line in every window, and drops the
;; stock mode line's coding-system and minor-mode clutter along with it.
;;
;; Windows no longer have a mode line to separate them, so mini-echo turns on
;; `window-divider-mode' to draw the borders instead.
(use-package mini-echo
  :ensure t
  :custom
  ;; Segments are rendered in reverse, so each list reads right to left. The
  ;; long form shows, from the left: evil state, branch, file, mode, position —
  ;; the same order as lualine. Swap "buffer-name" for "shrink-path" to get an
  ;; abbreviated full path instead of just the file name.
  (mini-echo-persistent-rule
   '(:long ("buffer-position" "major-mode" "buffer-name" "vcs" "evil")
     :short ("buffer-position" "buffer-name" "evil")))
  ;; Without this a full-width line wraps into a second one.
  (mini-echo-right-padding 1)
  :config
  ;; mini-echo's palette is the raw X11 "red", "green", "blue" and so on, much
  ;; louder than anything in flexoki. Point the base colours at the theme's own
  ;; accents; every other mini-echo face inherits from these seven. Clearing
  ;; :foreground is what lets :inherit take over, and keeps light/dark tracking.
  (dolist (mapping '((mini-echo-blue    . flexoki-themes-blue)
                     (mini-echo-green   . flexoki-themes-green)
                     (mini-echo-yellow  . flexoki-themes-yellow)
                     (mini-echo-red     . flexoki-themes-red)
                     (mini-echo-magenta . flexoki-themes-magenta)
                     (mini-echo-cyan    . flexoki-themes-cyan)
                     (mini-echo-gray    . shadow)))
    (set-face-attribute (car mapping) nil
                        :foreground 'unspecified
                        :inherit (cdr mapping)))

  ;; lualine colours the mode indicator and greys everything else out. Let the
  ;; evil state keep its colour and let these recede.
  (set-face-attribute 'mini-echo-major-mode nil :inherit 'shadow)
  (set-face-attribute 'mini-echo-buffer-position nil :inherit 'shadow)

  (mini-echo-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Dired
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Out of the box dired is a full `ls -l' dump: permissions, link count, owner,
;; group, size and date on every line. oil shows names and icons, so do that.
;; `(' toggles the columns back when they're actually wanted.
(use-package dired
  :ensure nil                           ; built in
  :hook (dired-mode . dired-hide-details-mode)
  :custom
  ;; macOS ships BSD ls, which doesn't understand --dired and says so on every
  ;; dired buffer. It also rules out GNU-only switches like
  ;; --group-directories-first, so directories sort in with everything else.
  (dired-use-ls-dired nil)
  ;; -A keeps dotfiles (oil: show_hidden) but drops the . and .. entries; `-'
  ;; already goes up a directory.
  (dired-listing-switches "-Alh")
  ;; oil opens directories in place. Without this, every directory visited
  ;; leaves its own buffer behind.
  (dired-kill-when-opening-new-dired-buffer t)
  ;; oil: delete_to_trash
  (delete-by-moving-to-trash t))

;; oil's devicons. nerd-icons is already configured for the completion UI.
(use-package nerd-icons-dired
  :ensure t
  :after nerd-icons
  :hook (dired-mode . nerd-icons-dired-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   Git
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Uncommitted changes in the gutter, like gitsigns. flexoki already styles the
;; diff-hl faces, so the colours need no help.
(use-package diff-hl
  :ensure t
  ;; `:hook' alone would defer loading, which would leave the global modes in
  ;; `:config' switched off until the first dired buffer.
  :demand t
  ;; Buffer-local, unlike the modes below, so it has to go on the hook.
  :hook (dired-mode . diff-hl-dired-mode-unless-remote)
  :custom
  ;; Same characters gitsigns uses.
  (diff-hl-margin-symbols-alist '((insert . "+")
                                  (change . "~")
                                  (delete . "_")
                                  (unknown . "?")
                                  (ignored . "i")))
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode)                ; update while typing, not just on save

  ;; A terminal frame has no fringe to draw in, so use the margin there.
  (unless (display-graphic-p)
    (diff-hl-margin-mode))

  (evil-define-key '(normal visual motion) 'global "]h" #'diff-hl-next-hunk)
  (evil-define-key '(normal visual motion) 'global "[h" #'diff-hl-previous-hunk))

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

;; Esc closes a picker, the way snacks.picker does. evil is not active in the
;; minibuffer, so this is a plain Emacs binding. Only `<escape>' is bound: in a
;; terminal, Alt-<key> arrives as ESC <key>, so binding "ESC" too would swallow
;; the minibuffer's M-p/M-n history bindings.
(keymap-set minibuffer-local-map "<escape>" #'abort-minibuffers)

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

;; Binding SPC in evil's global state map isn't enough: evil-collection marks
;; maps like `dired-mode-map' as overriding, and evil ranks intercept maps above
;; overriding maps above global state maps. Without this, SPC in dired is
;; `dired-next-line' and the leader is silently dead there, as in magit and Info.
(define-minor-mode my-leader-mode
  "Make SPC the leader key in every buffer."
  :global t
  :keymap (make-sparse-keymap))

(dolist (state '(normal visual motion))
  (evil-define-key state my-leader-mode-map (kbd "SPC") my-leader-map)
  (evil-make-intercept-map
   (evil-get-auxiliary-keymap my-leader-mode-map state t) state))

(my-leader-mode 1)

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
