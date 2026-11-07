;;; magit-config.el --- Git con Magit -*- lexical-binding: t; -*-

;;; Commentary:
;; Interfaccia a git; serve `git' nel PATH (su Windows: Git for Windows),
;; senza `git' il modulo resta spento.
;; C-x g lo lega già Magit (`magit-define-global-key-bindings'): qui è
;; solo esplicito.

;;; Code:

(use-package magit
  :ensure t
  :if (executable-find "git")
  :bind (("C-x g" . magit-status)))

(provide 'magit-config)

;;; magit-config.el ends here
