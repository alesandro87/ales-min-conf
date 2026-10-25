;;; markdown-config.el -*- lexical-binding: t; -*-
(use-package markdown-mode
  :ensure t
  :mode ("README\\.md\\'" . gfm-mode)
  :custom
  (markdown-fontify-code-blocks-natively t)
  :bind (:map markdown-mode-map
              ("C-c C-e" . markdown-do))
  :config
  ;; Anteprima ed export con pandoc solo se c'è; altrimenti resta il
  ;; default del pacchetto ("markdown")
  (when (executable-find "pandoc")
    (setq markdown-command "pandoc")))

(provide 'markdown-config)
