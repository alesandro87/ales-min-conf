(use-package go-mode
  :ensure t
  :hook ((go-mode . eglot-ensure)
         (before-save . gofmt-before-save))

  :bind (:map go-mode-map
              ("M-?" . xref-find-references)
              ("M-." . xref-find-definitions)
              ("M-," . xref-pop-marker-stack)
              ;; ("M-*" . pop-tag-mark) ;; Jump back after godef-jump
              ("C-c m r" . go-run))
  :config
  (setq gofmt-command "goimports"))

(provide 'go-config)
