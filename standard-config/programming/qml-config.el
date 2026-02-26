(use-package qml-mode
  :ensure t
  :mode "\\.qml\\'"
  :config
  (add-to-list 'eglot-server-programs
               '(qml-mode . ("/usr/bin/qmlls6")))
  :hook
  (qml-mode . eglot-ensure)
  )

(provide 'qml-config)
