(use-package yasnippet
  ;; yasnippet
  :ensure t
  :hook ((text-mode
          prog-mode
          conf-mode
          markdown-mode-hook
          snippet-mode) . yas-minor-mode-on)
  ;; :init
  )

(use-package yasnippet-snippets
  ;; load all snippet
  :ensure t
  :config
  (yasnippet-snippets-initialize)
  (yas-reload-all))

(provide 'yasnippet-config)
