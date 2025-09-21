;;; go-config.el -- single configuration for golang

(use-package go-mode
  :ensure t
  :hook ((go-mode . eglot-ensure)
         (before-save . gofmt-before-save))
  :config
  (setq gofmt-command "goimports"))

(with-eval-after-load 'eglot
  ;; Server per Go
  (add-to-list 'eglot-server-programs
               '(go-mode . ("gopls")))
  
  ;; Opzioni per gopls (opzionale)
  (setq-default eglot-workspace-configuration
                '((gopls
                   (staticcheck . t)
                   (matcher . "CaseSensitive")))))
