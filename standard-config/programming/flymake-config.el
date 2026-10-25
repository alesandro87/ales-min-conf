;;; flymake-config.el -*- lexical-binding: t; -*-
;; Flymake si attiva tramite eglot.  M-n/M-p e non M-g n/M-g p, che
;; restano a next-error (compile, grep).
(use-package flymake
  :ensure nil
  :bind (:map flymake-mode-map
              ("M-n" . flymake-goto-next-error)
              ("M-p" . flymake-goto-prev-error)))

(provide 'flymake-config)
