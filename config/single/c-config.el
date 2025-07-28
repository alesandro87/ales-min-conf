;;; c-config.el -- single configuration
;;; c and c++ mode 

(use-package cc-mode
  :ensure nil
  :config
  ;; Configurazione di base per C++
  (setq c-default-style "linux"
        c-basic-offset 4)
  
  ;; Configurazione specifica per Qt
  (c-set-offset 'innamespace 0)
  (c-set-offset 'access-label -2)
  (c-set-offset 'case-label 0))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode) . ("clangd" "--compile-commands-dir=build-arm"))))

;; Hook per C++
(defun my-cpp-mode-hook ()
  "Hook personalizzato per C++"
  (eglot-ensure)
  (electric-pair-mode 1)
  ;(my-cpp-eglot-config)
   
  ;; Keybindings specifici per C++
  (local-set-key (kbd "C-c C-c") 'compile)
  (local-set-key (kbd "C-c C-r") 'recompile)
  (local-set-key (kbd "C-c m") 'man))

(add-hook 'c++-mode-hook 'my-cpp-mode-hook)
(add-hook 'c-mode-hook 'my-cpp-mode-hook)

;; Clang-format
(use-package clang-format
  :ensure t
  :bind (:map c-mode-base-map
              ("C-c f" . clang-format-buffer))
  :config
  ;; Abilita clang-format su save (opzionale)
  ;; (add-hook 'before-save-hook #'clang-format-buffer nil t)
  (add-hook 'c-mode-common-hook
            (lambda ()
              (clang-format-on-save-mode 1)))) ;; formato automatico al save

;; Configurazione per CMake
(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

