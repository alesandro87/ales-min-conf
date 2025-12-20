(use-package bb-mode
  :load-path "./config/mode/"
  :mode (("\\.bbappend\\'" . bb-mode)
         ("\\.bb\\'" . bb-mode)
         ("\\.inc\\'" . bb-mode)
         ("\\.bbclass\\'" . bb-mode)
         ("\\.conf\\'" . bb-mode))
  :config (message "bb-mode activated"))

(provide 'bb-config)
