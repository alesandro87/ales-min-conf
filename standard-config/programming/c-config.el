(use-package cc-mode
  :ensure t
  :config
  ;; Configurazione di base per C++
  (setq c-default-style "linux" c-basic-offset 4)

  ;; Configurazione specifica per Qt
  (c-set-offset 'innamespace 0)
  (c-set-offset 'access-label -2)
  (c-set-offset 'case-label 0))

(dolist (hook '(c-ts-mode-hook c++-ts-mode-hook c-mode-hook c++-mode-hook))
  (add-hook hook #'hs-minor-mode))
  
(add-hook 'c++-ts-mode-hook
          (lambda ()
            (setq-local c-ts-mode-indent-offset 4)
            (setq-local c-ts-mode-indent-style 'k&r)))

;;; - permette l'utilizzo di .dir-locals.el 
(defvar-local auto-format-on-save nil
  "Se non-nil (impostato via .dir-locals.el), formatta con eglot al salvataggio.")
(put 'auto-format-on-save 'safe-local-variable #'booleanp)

(add-hook 'before-save-hook
          (lambda ()
            (when (and (bound-and-true-p auto-format-on-save)
                       (bound-and-true-p eglot--managed-mode))
              (eglot-format-buffer))))
;;;

;; Configurazione per CMake
(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

(defun my-cmake-configure (root)
  (interactive "DProject root: ")
  (let ((build-dir (concat root "mbuild")))
    (unless (file-exists-p build-dir)
      (make-directory build-dir))
    (compile (format "cmake -S %s -B %s" root build-dir))))

(defun my-cmake-build (build-dir)
  (interactive "DBuild dir: ")
  (compile (format "cmake --build %s -j" build-dir)))

(defun my-cmake-clean (build-dir)
  (interactive "DBuild dir: ")
  (compile (format "cmake --build %s --target clean" build-dir)))

(global-set-key (kbd "C-c m c") #'my-cmake-configure)
(global-set-key (kbd "C-c m b") #'my-cmake-build)

;; Configurazione Eglot per C e C++
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c++-ts-mode c-ts-mode c-mode) . ("clangd"))))


;; (global-set-key (kbd "C-c m k") #'my-cmake-clean)
;; (global-set-key (kbd "C-c m r") #'recompile)

(provide 'c-config)
