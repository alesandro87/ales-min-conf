;;; c-config.el -- single configuration
;;; c and c++ mode 

(use-package cc-mode
  :ensure nil
  :config
  ;; Configurazione di base per C++
  (setq c-default-style "linux"
        c-basic-offset 4)
  
  ;; Configurazione specifica per Qt
  (c-set-offset 'innamespace 0)
  (c-set-offset 'access-label -2)
  (c-set-offset 'case-label 0))
