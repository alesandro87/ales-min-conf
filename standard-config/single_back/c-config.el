;;; c-config.el -- single configuration
;;; c and c++ mode

;; Tree-sitter setup
(when (treesit-available-p)
  ;; Installa automaticamente le grammatiche se non presenti
  (setq treesit-language-source-alist
        '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")))
  
  ;; Installa la grammatica cpp se mancante
  (unless (treesit-language-available-p 'cpp)
    (treesit-install-language-grammar 'cpp))
  
  ;; Usa tree-sitter SOLO per C++, non per C
  (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode)))

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

;; Configurazione Eglot
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c++-ts-mode c-mode) . ("clangd" "--compile-commands-dir=build-arm"))))

;; Hook unificato per C/C++
(defun my-c-cpp-mode-hook ()
  "Hook personalizzato per C e C++"
  (eglot-ensure)
  (electric-pair-mode 1)
  
  ;; clang format when save c/c++ file
  (add-hook 'before-save-hook #'clang-format-buffer nil t)
  
  ;; Keybindings specifici
  (local-set-key (kbd "C-c C-c") 'compile)
  (local-set-key (kbd "C-c C-r") 'recompile)
  (local-set-key (kbd "C-c m") 'man))

;; Applica l'hook a tutti i mode C/C++
(add-hook 'c++-ts-mode-hook 'my-c-cpp-mode-hook)
(add-hook 'c-mode-hook 'my-c-cpp-mode-hook)
(add-hook 'c++-mode-hook 'my-c-cpp-mode-hook)

(use-package clang-format
  :ensure t
  :bind ((:map c-mode-base-map
               ("C-c f" . clang-format-buffer)
               ("TAB" . my/clang-format-line-or-region))
         (:map c++-ts-mode-map
               ("C-c f" . clang-format-buffer)
               ("TAB" . my/clang-format-line-or-region)))
  :config
  (defun my/clang-format-line-or-region ()
    "Formatta la riga corrente o la regione selezionata con clang-format."
    (interactive)
    (if (use-region-p)
        (clang-format-region (region-beginning) (region-end))
      (clang-format-region (line-beginning-position) (line-end-position)))))

;; Disattiva l'indentazione automatica di Tree-sitter per C++ (clang-format si occupa di tutto)
(setq c++-ts-mode-indent-offset 0)

;; Configurazione per CMake
(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

(provide 'c-config)
