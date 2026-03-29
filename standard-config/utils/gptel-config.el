(use-package gptel
  :config
  (setq gptel-backend (gptel-make-anthropic "Claude"
                        :key (getenv "CLAUDE_API_KEY")
                        :stream t)
        ;; claude-sonnet-4-6: ottimo bilanciamento velocità/qualità
        ;; claude-haiku-4-5-20251001: più veloce e leggero (usa questo per risposte rapide)
        gptel-model 'claude-sonnet-4-6))

(provide 'gptel-config)
