;;; projectile-config.el --- Project management with Projectile -*- lexical-binding: t; -*-

(defun projectile-consult-find ()
  "Run `consult-find' from the current Projectile project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (consult-find default-directory)))

(defun projectile-consult-ripgrep ()
  "Run `consult-ripgrep' from the current Projectile project root."
  (interactive)
  (let ((default-directory (projectile-project-root)))
    (consult-ripgrep default-directory)))

(use-package projectile
  :ensure t
  :init
  (projectile-mode 1)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :custom
  ;; Keep `completing-read' so Vertico/Orderless enhance Projectile too.
  (projectile-completion-system 'default)
  (projectile-sort-order 'recentf)
  (projectile-enable-caching t)
  :config
  (setq projectile-switch-project-action #'projectile-dired)
  (define-key projectile-command-map (kbd "C-f") #'projectile-consult-find)
  (define-key projectile-command-map (kbd "C-s") #'projectile-consult-ripgrep))

(provide 'projectile-config)
