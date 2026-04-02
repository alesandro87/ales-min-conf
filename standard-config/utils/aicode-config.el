(use-package ai-code
  :config
  (ai-code-set-backend 'codex)
  (global-set-key (kbd "C-c a") #'ai-code-menu))

(provide 'aicode-config)
