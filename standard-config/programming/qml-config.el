(use-package qml-mode
  :ensure t
  :mode "\\.qml\\'"
  :hook
  (qml-mode . eglot-ensure)
  :config
  ;; Register the QML server only after Eglot is loaded. Otherwise
  ;; `eglot-server-programs' may still be unbound and QML buffers fall back
  ;; to the generic JavaScript server because `qml-mode' derives from `js-mode'.
  (with-eval-after-load 'eglot
    ;; Resolve the first available QML language server executable and register
    ;; it for `qml-mode' so Eglot doesn't reuse the generic JS mapping.
    (when-let ((server-contact
                (when-let ((server (or (executable-find "qmlls6")
                                       (executable-find "qmlls"))))
                  (list server))))
      (add-to-list 'eglot-server-programs
                   `(qml-mode . ,server-contact)))))

(provide 'qml-config)
