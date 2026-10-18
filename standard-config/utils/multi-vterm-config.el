;;; multi-vterm-config.el -*- lexical-binding: t; -*-
(use-package multi-vterm
  :ensure t
  :bind (("C-c v t" . multi-vterm)
         ("C-c v n" . multi-vterm-next)
         ("C-c v p" . multi-vterm-prev)
         ("C-c v d" . multi-vterm-dedicated-toggle)
         ("C-c v o" . multi-vterm-dedicated-open)
         ("C-c v c" . multi-vterm-dedicated-close)
         ("C-c v r" . multi-vterm-project))   ;; r = root del progetto
  :init
  ;; multi-vterm usa projectile se riesce a caricarlo, anche solo
  ;; installato; già definita a nil, usa project.el come consult ed eglot
  ;; (project-config.el).
  (defvar multi-vterm-projectile-installed-p nil)
  :custom
  (multi-vterm-dedicated-window-height 30))

(provide 'multi-vterm-config)
