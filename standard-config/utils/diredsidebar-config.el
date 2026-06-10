(use-package dired-sidebar
  :bind (("M-0" . dired-sidebar-toggle-sidebar))
  :config

  ;; aspetto
  (setq dired-sidebar-width 30)
  (setq dired-sidebar-subtree-line-prefix "  ")
  (setq dired-sidebar-theme 'ascii)
  (setq dired-sidebar-use-term-integration nil)
  (setq dired-sidebar-use-custom-font nil)

  ;; ordinamento
  (setq dired-listing-switches "-alh --group-directories-first")

  ;; comportamento
  (setq dired-sidebar-follow-file t)
  (setq dired-sidebar-pop-to-sidebar-on-toggle-open t)

  ;; look minimal
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (hl-line-mode 1)
              (display-line-numbers-mode -1)
              (setq-local truncate-lines t)
              (setq-local window-size-fixed 'width)
              (setq-local cursor-type nil)
              (setq-local left-margin-width 1))))

(provide 'diredsidebar-config)
