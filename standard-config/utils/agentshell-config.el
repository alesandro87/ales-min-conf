(use-package agent-shell
  ; :vc (:url "https://github.com/xenodium/agent-shell" :branch "main")
  :config
  ;; la chiave API la prendi da authinfo o come preferisci
  ;; (setq agent-shell-goose-authentication
  ;;       '(:openai-api-key . "sk-aQSTRAJZOAbvCnUqgCDzMDB1THEEciAKIH0bCwUo3welCjuW")))
  (setq agent-shell-goose-authentication
        '((:openai-api-key . "sk-aQSTRAJZOAbvCnUqgCDzMDB1THEEciAKIH0bCwUo3welCjuW"))))

(provide 'agentshell-config)
