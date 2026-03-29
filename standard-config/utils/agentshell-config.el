(use-package agent-shell
  ; :vc (:url "https://github.com/xenodium/agent-shell" :branch "main")
  :config
  ;; La chiave API viene letta dalla variabile d'ambiente OPENAI_API_KEY
  ;; Impostala nel tuo shell: export OPENAI_API_KEY="sk-..."
  (setq agent-shell-goose-authentication
        `((:openai-api-key . ,(getenv "OPENAI_API_KEY")))))

(provide 'agentshell-config)
