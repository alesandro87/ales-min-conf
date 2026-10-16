;;; projectile-config.el --- Project management with Projectile -*- lexical-binding: t; -*-

;; Projectile configuration integrated with Consult.
;;
;; Key bindings:
;;   C-c p C-f  `consult-find'    - search file names across the project
;;   C-c p C-s  `consult-ripgrep' - search text content across the project
;;
;; Both commands operate on the top-level project root, correctly handling
;; git submodules. For non-git projects, placing a `.project-root' file in
;; the desired root directory achieves the same result.

;;; Code:

(use-package ripgrep
  :ensure t)

(defun my/projectile--toplevel-root ()
  "Return the top-level project root directory.
First looks for a `.project-root' marker file traversing up the directory tree.
If not found and the project is managed by git, traverses up to the superproject
root, correctly handling submodules.
Falls back to `projectile-project-root' in all other cases."
  (or (locate-dominating-file default-directory ".project-root")
      (let ((root (with-temp-buffer
                    ;; git chiamato direttamente (niente shell): funziona anche
                    ;; con cmd.exe; stderr scartato, errore o git assente → "".
                    (if (eq 0 (ignore-errors
                                (process-file "git" nil '(t nil) nil "rev-parse"
                                              "--show-superproject-working-tree")))
                        (string-trim (buffer-string))
                      ""))))
        (if (string-empty-p root)
            (projectile-project-root)
          root))))

(defun my/projectile-consult-find ()
  "Run `consult-find' from the top-level project root."
  (interactive)
  (let ((default-directory (my/projectile--toplevel-root)))
    (consult-find default-directory)))

(defun my/projectile-consult-ripgrep ()
  "Run `consult-ripgrep' from the top-level project root."
  (interactive)
  (let ((default-directory (my/projectile--toplevel-root)))
    (consult-ripgrep default-directory)))

(use-package projectile
  :ensure t
  :after ripgrep
  :init
  (projectile-mode 1)
  :custom
  (projectile-completion-system 'default)
  (projectile-sort-order 'recentf)
  (projectile-enable-caching t)
  :config
  (setq projectile-switch-project-action #'projectile-dired)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (define-key projectile-command-map (kbd "C-f") #'my/projectile-consult-find)
  (define-key projectile-command-map (kbd "C-s") #'my/projectile-consult-ripgrep))
 
;; (with-eval-after-load 'projectile
;;   (define-key projectile-command-map (kbd "C-f") #'my/projectile-consult-find)
;;   (define-key projectile-command-map (kbd "C-s") #'my/projectile-consult-ripgrep))


(provide 'projectile-config)

;;; projectile-config.el ends here
