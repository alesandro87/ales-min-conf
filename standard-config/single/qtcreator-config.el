;;; qtcreator-config.el -- single configuration

(require 'use-package)

(use-package qml-mode
  :ensure t
  :mode "\\.qml\\'"
  :hook
  (qml-mode . eglot-ensure)
  :config
  (with-eval-after-load 'eglot
    (when-let ((server-contact
                (when-let ((server (or (executable-find "qmlls6")
                                       (executable-find "qmlls"))))
                  (list server))))
      (add-to-list 'eglot-server-programs
                   `(qml-mode . ,server-contact)))))


(use-package qtcreator-mode
  :load-path "~/.emacs.d/ales-min-conf/config/mode/"
                                        ;:ensure t
  ;; :mode (("\\.h\\'" . qtcreator-mode)
  ;;        ("\\.hpp\\'" . qtcreator-mode)
  ;;        ("\\.cpp\\'" . qtcreator-mode))

  :config
  (message "qtcreator-mode activated")
  )
