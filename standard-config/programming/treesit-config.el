;; Tree-sitter setup

(when (treesit-available-p)
  ;; Sorgenti per M-x treesit-install-language-grammar (non installa nulla
  ;; da solo)
  (setq treesit-language-source-alist
        '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")
          ;(c "https://github.com/tree-sitter/tree-sitter-c")
          ;(common-lisp "https://github.com/thehamsta/tree-sitter-commonlisp")
          (bash "https://github.com/tree-sitter/tree-sitter-bash")
          (python "https://github.com/tree-sitter/tree-sitter-python" "v0.21.0")))

  ;; Rimappa al mode tree-sitter solo se la grammatica è installata,
  ;; altrimenti resta il mode classico (es. Windows senza grammatiche).
  ;; Controllato all'avvio: dopo aver installato una grammatica va riavviato.
  (dolist (remap '((c++-mode    c++-ts-mode    cpp)
                   ;(common-lisp-mode common-lisp-ts-mode common-lisp)
                   (python-mode python-ts-mode python)
                   (sh-mode     bash-ts-mode   bash)))
    (when (treesit-language-available-p (nth 2 remap))
      (add-to-list 'major-mode-remap-alist (cons (nth 0 remap) (nth 1 remap)))))

  ;; C resta sempre classico (gli hook sono su c-mode).  Senza queste voci,
  ;; caricato c-ts-mode.el, i default di Emacs 30 rimapperebbero c-mode e
  ;; c-or-c++-mode (.h) ai mode tree-sitter; nil = usa il mode stesso.
  (add-to-list 'major-mode-remap-alist '(c-mode . nil))
  (add-to-list 'major-mode-remap-alist '(c-or-c++-mode . nil)))

;; guarda i file c-config.el come è fatto per gli altri linugaggi

(provide 'treesit-config)
