;;; ibuffer-config.el --- Clean ibuffer configuration -*- lexical-binding: t; -*-

(use-package ibuffer
  :ensure t
  :bind (("C-x C-b" . ibuffer))
  :config
  ;; Gruppi personalizzati (Org in fondo)
  (setq ibuffer-saved-filter-groups
        '(("default"
           ("Dired" (mode . dired-mode))
           ("Shell" (or (mode . eshell-mode)
                        (mode . shell-mode)
                        (mode . term-mode)))
           ("Yocto" (or (mode . bb-mode)))
           ("C/C++" (or (mode . c-mode)
                        (mode . c++-mode)
                        (mode . cmake-mode)))
           ("Emacs Lisp" (mode . emacs-lisp-mode))
           ("Lisp" (mode . lisp-mode))
           ("Emacs internals" (or (name . "^\\*scratch\\*$")
                                  (name . "^\\*Messages\\*$")))
           ("Altro" (starred-name . ".*"))
           ("Org" (mode . org-mode))))) ;; Org in fondo

  ;; Applica i gruppi quando si apre ibuffer
  (add-hook 'ibuffer-mode-hook
            (lambda ()
              (ibuffer-switch-to-saved-filter-groups "default")
              (setq ibuffer-show-empty-filter-groups nil)))

  ;; Ordinamento predefinito alfabetico
  (setq ibuffer-default-sorting-mode 'alphabetic)

  ;; Formato delle colonne
  (setq ibuffer-formats
        '((mark modified read-only locked " "
                (name 25 25 :left :elide)
                " "
                (size 9 -1 :right)
                " "
                (mode 16 16 :left :elide)
                " "
                filename-and-process))))

(provide 'ibuffer-config)
;;; ibuffer-config.el ends here
