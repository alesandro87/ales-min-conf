(use-package gptel
  :ensure t
  :config
  
  (setq gptel-model 'sonar
        gptel-backend (gptel-make-perplexity "Perplexity"
                        :key (getenv "PERPLEXITY_API_KEY")
                        :stream t)))

(provide 'gptel-config)


