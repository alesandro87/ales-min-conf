;;; dart-config.el -*- lexical-binding: t; -*-
;; dart-config.el
(when (treesit-available-p)
  ;; `treesit-language-source-alist' non supporta un hash di commit come
  ;; REVISION quando URL è un repository remoto
  (defvar my/dart-grammar-src
    (expand-file-name "tree-sitter-src/tree-sitter-dart" user-emacs-directory)
    "Clone locale di tree-sitter-dart, usato per pinnare un commit via hash.")

  (defun my/dart-install-grammar ()
    "Installa la grammatica tree-sitter per Dart, pinnata al commit
c8e7cbb (ABI 14) per evitare il version-mismatch con Emacs.  Da
lanciare a mano una tantum quando serve: M-x my/dart-install-grammar."
    (interactive)
    (unless (file-directory-p my/dart-grammar-src)
      (make-directory (file-name-directory my/dart-grammar-src) t)
      (call-process "git" nil nil nil "clone" "--quiet"
                    "https://github.com/UserNobody14/tree-sitter-dart"
                    my/dart-grammar-src))
    (setf (alist-get 'dart treesit-language-source-alist nil nil #'equal)
          (list my/dart-grammar-src "c8e7cbb"))
    (treesit-install-language-grammar 'dart)))

(defun my/dart-ts-setup ()
  (eglot-ensure)
  (electric-pair-local-mode 1))

(use-package dart-ts-mode
  :vc (:url "https://github.com/50ways2sayhard/dart-ts-mode" :rev :newest)
  :mode "\\.dart\\'"
  :hook (dart-ts-mode . my/dart-ts-setup))

(provide 'dart-config)
