;;; post-init.el --- Configurazione principale cross-platform -*- lexical-binding: t; no-byte-compile: t; -*-

;; Radice del progetto, ricavata dalla posizione reale di questo file
;; (risolvendo il symlink in `user-emacs-directory'), così il repo può
;; stare ovunque.
(defvar my/ales-min-conf-dir
  (file-name-directory (file-truename (or load-file-name buffer-file-name)))
  "Directory radice del progetto ales-min-conf.")

;; add to path
(add-to-list 'load-path (expand-file-name "small-config/" my/ales-min-conf-dir))
(add-to-list 'load-path (expand-file-name "standard-config/" my/ales-min-conf-dir))

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
