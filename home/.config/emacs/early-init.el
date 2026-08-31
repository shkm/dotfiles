;;; early-init.el --- Runs before package init and the first frame -*- lexical-binding: t; -*-

;; Raise the GC threshold for startup; init.el restores it at the end.
(defvar my-initial-gc-threshold gc-cons-threshold)
(setq gc-cons-threshold (* 128 1024 1024))

;; Warnings from third-party packages aren't actionable, and the native
;; compiler is chatty on first install of every package.
(setq native-comp-async-report-warnings-errors 'silent)
(setq warning-suppress-log-types '((comp) (bytecomp)))

(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message (user-login-name))

;; `user-emacs-directory' is a symlink into the dotfiles repo, so keep generated
;; artefacts out of it. Must be set before package.el initialises.
(defvar my-state-dir (expand-file-name "~/.local/state/emacs/")
  "Directory for generated Emacs state: packages, history, backups.")

(setq package-user-dir (expand-file-name "elpa/" my-state-dir))
(when (and (fboundp 'startup-redirect-eln-cache) (native-comp-available-p))
  (startup-redirect-eln-cache (expand-file-name "eln-cache/" my-state-dir)))

;; No toolbar, menu bar or scroll bars.
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;;; early-init.el ends here
