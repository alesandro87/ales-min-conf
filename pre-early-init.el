;;; pre-early-init.el --- DESCRIPTION -*- no-byte-compile: t; lexical-binding: t; -*-

;; configuration only in debug phase
;; (setq debug-on-error t)

;; minimal
(setq minimal-emacs-ui-features '(context-menu tool-bar menu-bar dialogs tooltips))

;; Funzioni helper per OS detection
(defun my/is-windows-p ()
  "Controlla se siamo su Windows."
  (eq system-type 'windows-nt))

(defun my/is-linux-p ()
  "Controlla se siamo su Linux."
  (eq system-type 'gnu/linux))

(defun my/is-wsl-p ()
  "Controlla se siamo su WSL."
  (and (my/is-linux-p)
       (getenv "WSL_DISTRO_NAME")))

(defun my/is-mac-p ()
  (eq system-type 'darwin))

;; Configurazioni molto precoci specifiche per OS
(when (my/is-windows-p)
  ;; Windows: configurazioni di sistema molto precoci
  (setq w32-pass-lwindow-to-system nil)
  (setq w32-lwindow-modifier 'super)
  (setq w32-rwindow-modifier 'super))

;;(when (my/is-linux-p)
  ;; Linux: variabili d'ambiente precoci
  ;; (setenv "BROWSER" "firefox"))
