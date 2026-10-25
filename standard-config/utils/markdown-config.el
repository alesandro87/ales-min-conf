;;; markdown-config.el -*- lexical-binding: t; -*-
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :custom
  (markdown-fontify-code-blocks-natively t)
  :bind (:map markdown-mode-map
              ("C-c C-e" . markdown-do))
  :config
  ;; Anteprima ed export con pandoc se c'è, anche se c'è markdown;
  ;; altrimenti resta il default del pacchetto
  (when (executable-find "pandoc")
    (setq markdown-command "pandoc")))

(provide 'markdown-config)
