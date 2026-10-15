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
