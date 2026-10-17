;;; qml-config.el -*- lexical-binding: t; -*-
(declare-function my/eglot-ensure-if-found "eglot-config" (&rest programs))
(declare-function eglot-alternatives "eglot" (alternatives))
(defun my/qml-setup ()
  "Eglot con qmlls; senza, niente eglot (non il server JavaScript)."
  (my/eglot-ensure-if-found "qmlls6" "qmlls"))

(use-package qml-mode
  :ensure t
  :mode "\\.qml\\'"
  :hook
  (qml-mode . my/qml-setup)
  :config
  ;; Register the QML server only after Eglot is loaded. Otherwise
  ;; `eglot-server-programs' may still be unbound and QML buffers fall back
  ;; to the generic JavaScript server because `qml-mode' derives from `js-mode'.
  (with-eval-after-load 'eglot
    ;; Register qmlls for `qml-mode' so Eglot doesn't reuse the generic JS
    ;; mapping.  `eglot-alternatives' picks the first available executable
    ;; per buffer, on the remote host for TRAMP files.
    (add-to-list 'eglot-server-programs
                 `(qml-mode . ,(eglot-alternatives '("qmlls6" "qmlls"))))))

(provide 'qml-config)
