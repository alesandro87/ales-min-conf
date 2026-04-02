(use-package gptel                      ;
  :config
  (let* ((claude  (gptel-make-anthropic "Claude"
                    :key (getenv "CLAUDE_API_KEY")
                    :stream t))
         (ollama  (gptel-make-ollama "Ollama"
                    :host "localhost:11434"
                    :stream t
                    :models '(qwen2.5-coder:7b)))
         ;; ↓ cambia qui: claude o ollama
         (default-backend claude)
         (default-model   'qwen2.5-coder:7b))
    (setq gptel-backend default-backend
          gptel-model   default-model)))

(provide 'gptel-config)
