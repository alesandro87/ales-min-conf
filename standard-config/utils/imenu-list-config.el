(use-package imenu-list
  :ensure t
  :bind (("C-'"
          . imenu-list-smart-toggle))
  :config
  (setq imenu-list-focus-after-activation t
        imenu-list-auto-resize t))

(provide 'imenu-list-config)
