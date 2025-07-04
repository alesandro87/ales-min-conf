;;; post-init.el --- Configurazione principale cross-platform -*- lexical-binding: t; no-byte-compile: t; -*-

(let ((small-mode (getenv "SMALL_MODE")))
  (if (string= small-mode "yes")
      ;; Modalità small: carica solo small.el
      (my/load-config "small.el")
    ;; Modalità normale: carica tutte le configurazioni
    (progn
      ;; Carica configurazioni comuni
      (my/load-config "common.el")
      ;; Carica configurazioni specifiche per OS
      (cond
       ((my/is-windows-p)
        (my/load-config "windows.el"))
       ((my/is-linux-p)
        (my/load-config "linux.el"))
       ((my/is-mac-p)
        (my/load-config "mac.el"))))))
