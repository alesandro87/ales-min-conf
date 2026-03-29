;;; ibuffer-config.el --- Clean ibuffer configuration -*- lexical-binding: t; -*-

(use-package ibuffer
  :ensure nil  ;; built-in
  :bind (("C-x C-b" . ibuffer))
  :config
  (setq ibuffer-saved-filter-groups
        '(("default"
           ("Go"           (mode . go-mode))
           ("C/C++"        (or (mode . c-mode)
                               (mode . c++-mode)
                               (mode . c++-ts-mode)))
           ("Qml"          (mode . qml-mode))
           ("Yocto"        (mode . bb-mode))
           ("CMake"        (mode . cmake-mode))
           ("Emacs Lisp"   (mode . emacs-lisp-mode))
           ("Lisp"         (mode . lisp-mode))
           ("Shell scripts" (or (mode . sh-mode)
                                (mode . bash-ts-mode)))
           ("Shell"        (or (mode . eshell-mode)
                               (mode . shell-mode)
                               (mode . term-mode)))
           ("VTerm"        (mode . vterm-mode))
           ("Dired"        (mode . dired-mode))
           ("Org"          (mode . org-mode))
           ("Emacs internals" (or (name . "^\\*scratch\\*$")
                                  (name . "^\\*Messages\\*$")))
           ("Altro"        (starred-name . ".*")))))  ;; sempre ultimo

  (add-hook 'ibuffer-mode-hook
            (lambda ()
              (ibuffer-switch-to-saved-filter-groups "default")
              (setq ibuffer-show-empty-filter-groups nil)
              (ibuffer-auto-mode 1)))

  (setq ibuffer-default-sorting-mode 'alphabetic)

  (setq ibuffer-formats
        '((mark modified read-only locked " "
                (name 40 40 :left :elide)
                " "
                (size 9 -1 :right)
                " "
                (mode 16 16 :left :elide)
                " "
                filename-and-process))))

(provide 'ibuffer-config)
;;; ibuffer-config.el ends here
