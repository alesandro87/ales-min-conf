(use-package sly
  :ensure t
  :config
  (setq inferior-lisp-program "/usr/bin/sbcl")
  (add-hook 'lisp-mode-hook 'sly-editing-mode))

(provide 'lisp-config)
