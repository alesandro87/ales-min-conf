(use-package plantuml-mode
  :ensure t
  :after org
  :mode ("\\.plantuml\\'" "\\.puml\\'")
  :config
  (setq plantuml-executable-path "/usr/bin/plantuml"
        plantuml-default-exec-mode 'executable
        org-plantuml-exec-mode 'plantuml)
  (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
  (setq plantuml-indent-level 2)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((plantuml . t))))

(provide 'plantuml-config)
