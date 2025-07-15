;;; ibuffer-config.el -- single configuration for ibuffer-config.el

;(global-set-key (kbd "C-x C-b") 'ibuffer)

(use-package ibuffer
  :ensure t
  :bind (("C-x C-b" . ibuffer)) ; Sostituisce la lista buffer standard
  :config
  (setq ibuffer-saved-filter-groups
        '(("default"
           ("dired" (mode . dired-mode))
           ("org" (name . "^.*org$"))
           ("clisp" (name . "^.*lisp$"))
           ("emacs" (or (name . "^\\*scratch\\*$")
                        (name . "^\\*Messages\\*$")))
           ("shell" (or (mode . eshell-mode)
                        (mode . shell-mode)))
           ("c++" (or ;(mode . python-mode)
                      (mode . c++-mode)
                      ;(mode . emacs-lisp-mode)
                      (mode . cmake-mode)))
           ("altro" (starred-name . ".*")))))
  (add-hook 'ibuffer-mode-hook
            (lambda ()
              (ibuffer-switch-to-saved-filter-groups "default")
              (setq ibuffer-show-empty-filter-groups nil))))
