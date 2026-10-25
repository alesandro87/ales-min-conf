;;; windows.el --- Configurazioni specifiche Windows -*- lexical-binding: t; -*-

;; only for windows start server
; (server-start)

;; Il font (my/font-setup) è in ales-config.el, uguale per Linux e Windows.

;; Path per Windows
;;(when (executable-find "git")
;;  (setq magit-git-executable (executable-find "git")))

;; Browser su Windows
;; (setq browse-url-browser-function 'browse-url-default-windows-browser)

;; Configurazioni specifiche Windows
(setq w32-pass-alt-to-system nil)

;; Avviato da un collegamento, Emacs parte nella sua cartella di
;; installazione: meglio la home dell'utente.
(when-let ((home (getenv "USERPROFILE")))
  (setq default-directory (file-name-as-directory home)))

;; vterm non funziona su Windows nativo (multi-vterm-config non viene
;; caricato): C-c v t apre eshell al suo posto.
(global-set-key (kbd "C-c v t") #'eshell)

(provide 'windows)
