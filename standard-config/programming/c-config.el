(use-package cc-mode
  :ensure t
  :config
  ;; Configurazione di base per C++
  (setq c-default-style "linux" c-basic-offset 4)

  ;; Configurazione specifica per Qt
  (c-set-offset 'innamespace 0)
  (c-set-offset 'access-label -2)
  (c-set-offset 'case-label 0))

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
               '((c++-ts-mode c-mode) . ("clangd" "--compile-commands-dir=./"))))


;; (global-set-key (kbd "C-c m k") #'my-cmake-clean)
;; (global-set-key (kbd "C-c m r") #'recompile)

(provide 'c-config)
