;;; projectile-config.el --- Project management with Projectile -*- lexical-binding: t; -*-

(use-package projectile
  :ensure t
  :init
  (projectile-mode 1)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :custom
  (projectile-completion-system 'default)
  (projectile-sort-order 'recentf)
  (projectile-enable-caching t)
  :config
  (setq projectile-switch-project-action #'projectile-dired))

(provide 'projectile-config)
