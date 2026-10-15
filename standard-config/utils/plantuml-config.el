(use-package plantuml-mode
  :ensure t
  :mode ("\\.plantuml\\'" "\\.puml\\'")
  :config
  (setq plantuml-executable-path "/usr/bin/plantuml"
        plantuml-default-exec-mode 'executable
        plantuml-indent-level 2))

;; Integrazione con Org: si applica quando Org viene caricato
(with-eval-after-load 'org
  (setq org-plantuml-exec-mode 'plantuml)
  (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
  (add-to-list 'org-babel-load-languages '(plantuml . t))
  (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages))

(provide 'plantuml-config)
