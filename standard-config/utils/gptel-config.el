(use-package gptel
  :config
  (setq gptel-backend (gptel-make-anthropic "Claude"
                        :key (getenv "CLAUDE_API_KEY")
                        :stream t)
        gptel-model 'claude-haiku-4-5))

(provide 'gptel-config)
