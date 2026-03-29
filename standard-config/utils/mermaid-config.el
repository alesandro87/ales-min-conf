(use-package mermaid-mode
  :ensure t
  :mode ("\\.mmd\\'" . mermaid-mode)
  :config)

(use-package ob-mermaid
  :ensure t
  :config
  (setq ob-mermaid-cli-path "/home/ales/.nvm/versions/node/v22.21.1/bin/mmdc"
        ob-mermaid-extra-args "-s 4"))

(provide 'mermaid-config)
