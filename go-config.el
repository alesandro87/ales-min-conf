;; Installazione dei pacchetti necessari per Go

;; (package-initialize)
(unless (package-installed-p 'go-mode)
  (package-refresh-contents)
  (package-install 'go-mode))

(unless (package-installed-p 'company-go)
  (package-refresh-contents)
  (package-install 'company-go))

(unless (package-installed-p 'flycheck-golangci-lint)
  (package-refresh-contents)
  (package-install 'flycheck-golangci-lint))

;; Configurazione di go-mode
(add-hook 'go-mode-hook
          (lambda ()
            (setq-local tab-width 4)
            (setq-local indent-tabs-mode nil)))

;; Configurazione di company-go
(add-hook 'go-mode-hook
          (lambda ()
            (company-mode t)))

;; Configurazione di flycheck-golangci-lint
(add-hook 'go-mode-hook
          (lambda ()
            (flycheck-mode t)
            (setq flycheck-golangci-lint-config (expand-file-name "~/.golangci.yml"))))
