(use-package plantuml-mode
  :ensure t
  :mode ("\\.plantuml\\'" "\\.puml\\'")
  :config
  (setq plantuml-executable-path "/usr/bin/plantuml"
        plantuml-default-exec-mode 'executable
        org-plantuml-exec-mode 'plantuml)
  (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t))))

(provide 'plantuml-config)
