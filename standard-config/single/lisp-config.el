;;; lisp-config.el -- Common Lisp environment
;;; Commentary:
;;; Configurazione base per Common Lisp e SLIME
;;; Code:

;; ---------------------------------------------------------
;; SLIME - Ambiente Common Lisp
;; ---------------------------------------------------------
(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "sbcl")
  (setq slime-contribs '(slime-fancy slime-quicklisp slime-asdf))
  
  :bind
  (("C-c s" . slime)
   :map slime-mode-map
   ("C-c C-d h" . slime-documentation-lookup)))


;; Disabilita Corfu per Common Lisp (usa il completamento di SLIME)
(add-hook 'lisp-mode-hook (lambda () (corfu-mode -1)))
(add-hook 'slime-repl-mode-hook (lambda () (corfu-mode -1)))

(provide 'lisp-config)
;;; lisp-config.el ends here
