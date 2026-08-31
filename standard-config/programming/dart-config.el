;; dart-config.el
(when (treesit-available-p)
  ;; `treesit-language-source-alist' non supporta un hash di commit come
  ;; REVISION quando URL è un repository remoto
  (defvar ap/dart-grammar-src
    (expand-file-name "tree-sitter-src/tree-sitter-dart" user-emacs-directory)
    "Clone locale di tree-sitter-dart, usato per pinnare un commit via hash.")

  (defun ap/dart-install-grammar ()
    "Installa la grammatica tree-sitter per Dart, pinnata al commit
c8e7cbb (ABI 14) per evitare il version-mismatch con Emacs.  Da
lanciare a mano una tantum quando serve: M-x ap/dart-install-grammar."
    (interactive)
    (unless (file-directory-p ap/dart-grammar-src)
      (make-directory (file-name-directory ap/dart-grammar-src) t)
      (call-process "git" nil nil nil "clone" "--quiet"
                    "https://github.com/UserNobody14/tree-sitter-dart"
                    ap/dart-grammar-src))
    (setf (alist-get 'dart treesit-language-source-alist nil nil #'equal)
          (list ap/dart-grammar-src "c8e7cbb"))
    (treesit-install-language-grammar 'dart)))

(defun ap/dart-ts-setup ()
  (eglot-ensure)
  (electric-pair-mode 1))

(use-package dart-ts-mode
  :vc (:url "https://github.com/50ways2sayhard/dart-ts-mode" :rev :newest)
  :mode "\\.dart\\'"
  :hook (dart-ts-mode . ap/dart-ts-setup))

(provide 'dart-config)
