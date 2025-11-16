;;; post-init.el --- Configurazione principale cross-platform -*- lexical-binding: t; no-byte-compile: t; -*-

;; aggiunge la cartella config al path
(add-to-list 'load-path (expand-file-name "./ales-min-conf/config/" user-emacs-directory))

(let ((small-config (getenv "SMALL")))
  (if (string= small-config "yes")
      ;; Modalità small: carica solo small.el
      (require 'small)))
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
