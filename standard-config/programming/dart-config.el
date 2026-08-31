;; dart-config.el
(when (treesit-available-p)
  (setf (alist-get 'dart treesit-language-source-alist nil nil #'equal)
        '("https://github.com/UserNobody14/tree-sitter-dart" "c8e7cbb"))

  ;; Installa la grammatica dart se mancante (hash pinnato per evitare
  ;; il mismatch ABI 15 vs 14 supportato da Emacs)
  (unless (treesit-language-available-p 'dart)
    (treesit-install-language-grammar 'dart)))

(defun ap/dart-ts-setup ()
  (eglot-ensure)
  (electric-pair-mode 1))

(use-package dart-ts-mode
  :vc (:url "https://github.com/50ways2sayhard/dart-ts-mode" :rev :newest)
  :mode "\\.dart\\'"
  :hook (dart-ts-mode . ap/dart-ts-setup))

(provide 'dart-config)
