;;; c-config.el -- single configuration
;;; c and c++ mode

;; Tree-sitter setup
(when (treesit-available-p)
  ;; Installa automaticamente le grammatiche se non presenti
  (setq treesit-language-source-alist
        '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")
          (c "https://github.com/tree-sitter/tree-sitter-c")))
  
  ;; Usa tree-sitter mode di default
  (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
  (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
  
  ;; Applica gli hook anche ai mode tree-sitter
  (add-hook 'c++-ts-mode-hook 'my-cpp-mode-hook)
  (add-hook 'c-ts-mode-hook 'my-cpp-mode-hook))

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
               '((c++-ts-mode c-ts-mode) . ("clangd" "--compile-commands-dir=build-arm"))))

;; Hook per C++
(defun my-cpp-mode-hook ()
  "Hook personalizzato per C++"
  (eglot-ensure)
  (electric-pair-mode 1)
  ;(my-cpp-eglot-config)

  ;; clang format when save c++ file
  (add-hook 'before-save-hook  #'clang-format-buffer nil t)
  
  ;; Keybindings specifici per C++
  (local-set-key (kbd "C-c C-c") 'compile)
  (local-set-key (kbd "C-c C-r") 'recompile)
  (local-set-key (kbd "C-c m") 'man))

(add-hook 'c++-ts-mode-hook 'my-cpp-mode-hook)
(add-hook 'c-ts-mode-hook 'my-cpp-mode-hook)

(use-package clang-format
  :ensure t
  :bind ((:map c-mode-base-map
               ("C-c f" . clang-format-buffer)
               ("TAB" . my/clang-format-line-or-region))
         (:map c-ts-mode-map
               ("TAB" . my/clang-format-line-or-region))
         (:map c++-ts-mode-map
               ("TAB" . my/clang-format-line-or-region)))
  :hook ((c-ts-mode . my/enable-clang-format-on-save)
         (c++-ts-mode . my/enable-clang-format-on-save)
         (c-mode . my/enable-clang-format-on-save)
         (c++-mode . my/enable-clang-format-on-save))
  :config
  (defun my/enable-clang-format-on-save ()
    "Abilita clang-format su save per buffer C/C++ con Tree-sitter."
    (add-hook 'before-save-hook #'clang-format-buffer nil t))
  
  (defun my/clang-format-line-or-region ()
    "Formatta la riga corrente o la regione selezionata con clang-format."
    (interactive)
    (if (use-region-p)
        (clang-format-region (region-beginning) (region-end))
      (clang-format-region (line-beginning-position) (line-end-position)))))

;; Disattiva l’indentazione automatica di Tree-sitter (clang-format si occupa di tutto)
  (setq c-ts-mode-indent-offset 0)
  (setq c++-ts-mode-indent-offset 0)

;; Configurazione per CMake
(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

