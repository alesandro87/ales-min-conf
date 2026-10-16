;;; markdown-config.el -*- lexical-binding: t; -*-
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :custom
  (markdown-command "pandoc")
  (markdown-fontify-code-blocks-natively t)
  :bind (:map markdown-mode-map
              ("C-c C-e" . markdown-do)))

(provide 'markdown-config)
