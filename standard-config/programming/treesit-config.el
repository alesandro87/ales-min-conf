t;; Tree-sitter setup

(when (treesit-available-p)
  ;; Installa automaticamente le grammatiche se non presenti
  (setq treesit-language-source-alist
        '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")
          (c "https://github.com/tree-sitter/tree-sitter-c")
          ;(common-lisp "https://github.com/thehamsta/tree-sitter-commonlisp")
          (bash "https://github.com/tree-sitter/tree-sitter-bash")
          (python "https://github.com/tree-sitter/tree-sitter-python")))

  
  ;; Rimappa automaticamente ai mode tree-sitter
  (setq major-mode-remap-alist
        '((c++-mode . c++-ts-mode)
          (c-mode . c-ts-mode)
          ;(common-lisp-mode . common-lisp-ts-mode)
          (python-mode . python-ts-mode)
          (bash-mode . bash-ts-mode))))

;; guarda i file c-config.el come è fatto per gli altri linugaggi

(provide 'treesit-config)
