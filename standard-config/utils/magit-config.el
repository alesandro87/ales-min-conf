;;; magit-config.el --- Git con Magit -*- lexical-binding: t; -*-

;;; Commentary:
;; Interfaccia a git; serve `git' nel PATH (su Windows: Git for Windows).
;; C-x g lo lega già Magit (`magit-define-global-key-bindings'): qui è
;; solo esplicito.

;;; Code:

(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)))

(provide 'magit-config)

;;; magit-config.el ends here
