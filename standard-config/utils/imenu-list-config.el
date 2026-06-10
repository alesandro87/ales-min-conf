(use-package imenu-list
  :ensure t
  :bind (("M-1" . imenu-list-smart-toggle))
  :config
  (setq imenu-list-focus-after-activation t
   imenu-list-auto-resize t
   imenu-list-position 'left))

(provide 'imenu-list-config)


