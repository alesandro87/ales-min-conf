;;; programming-integrations.el -- Programming mode configurations

;; Configurazione Eglot per C e C++
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c++-ts-mode c-mode) . ("clangd" "--compile-commands-dir=build-arm"))))

;; Hook per C e C++
(defun my-cpp-mode-hook ()
  "Hook personalizzato per C e C++"
  (eglot-ensure)
  (electric-pair-mode 1)
  ;; clang format when save c/c++ file
  ;; (add-hook 'before-save-hook #'clang-format-buffer nil t)
  
  ;; Keybindings specifici per C/C++
  (local-set-key (kbd "C-c C-c") 'compile)
  (local-set-key (kbd "C-c C-r") 'recompile)
  (local-set-key (kbd "C-c m") 'man))

;; Applica l'hook a C++ tree-sitter mode e C mode standard
(add-hook 'c++-ts-mode-hook 'my-cpp-mode-hook)
(add-hook 'c-mode-hook 'my-cpp-mode-hook)

;; Hook per Go
(defun my-go-mode-hook ()
  (eglot-ensure)
  (electric-pair-mode 1))

(add-hook 'go-mode-hook 'my-go-mode-hook)

;; Hook for org-mode
(add-hook 'org-mode-hook (lambda ()
                           (setq-local completion-at-point-functions
                                       (list #'cape-dabbrev     ; Parole già scritte
                                             #'cape-file        ; Percorsi file
                                             #'cape-dict        ; Dizionario parole
                                             ;; #'cape-emoji
                                             ))))

(provide 'programming-integrations)
