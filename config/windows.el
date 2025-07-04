;;; windows.el --- Configurazioni specifiche Windows -*- lexical-binding: t; -*-

;; only for windows start server
; (server-start)

;; Font per Windows
(when (display-graphic-p)
  (set-face-attribute 'default nil :font "Consolas-12"))
  ;; (set-face-attribute 'default nil :font "Fira Code-12"))
  ;;  (set-frame-font "Fira Code-10" t t))
  ;; (set-frame-font "Iosevka-12" t t))
  ;;(set-face-attribute 'default nil :font "Iosevka-12"))

  ;; (set-face-attribute 'default nil :font "Source Code Pro Medium-11.0"))

;; Path per Windows
;;(when (executable-find "git")
;;  (setq magit-git-executable (executable-find "git")))

;; Browser su Windows
;; (setq browse-url-browser-function 'browse-url-default-windows-browser)

;; Configurazioni specifiche Windows
(setq w32-pass-alt-to-system nil)

;;
(setq default-directory "C:/Users/atanasio/Work/")       ; Adatta al tuo username

