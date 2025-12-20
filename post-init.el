;;; post-init.el --- Configurazione principale cross-platform -*- lexical-binding: t; no-byte-compile: t; -*-

;; add to path
(add-to-list 'load-path (expand-file-name "./ales-min-conf/small-config/" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "./ales-min-conf/standard-config/" user-emacs-directory))

;; read the env and choose the right configuration
(let ((small-config (getenv "SMALL")))
  (if (string= small-config "yes")
      (require 'small-config)
  (require 'standard-config)))

;      (my/load-config "small.el")))

    ;; Modalità normale: carica tutte le configurazioni
    ;; (progn
    ;;   ;; Carica configurazioni comuni
    ;;   (my/load-config "common.el")
    ;;   ;; Carica configurazioni specifiche per OS
    ;;   (cond
    ;;    ((my/is-windows-p)
    ;;     (my/load-config "windows.el"))
    ;;    ((my/is-linux-p)
    ;;     (my/load-config "linux.el"))
    ;;    ((my/is-mac-p)
    ;;     (my/load-config "mac.el"))))))
