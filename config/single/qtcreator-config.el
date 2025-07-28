;;; qtcreator-config.el -- single configuration

(require 'use-package)

(use-package qml-mode
  :ensure t
  :mode "\\.qml\\'"
  :config
  (add-to-list 'eglot-server-programs
               '(qml-mode . ("/opt/Qt/6.5.9/gcc_64/bin/qmlls")))
  :hook
  (qml-mode . eglot-ensure)
  )


(use-package qtcreator-mode
  :load-path "~/.emacs.d/ales-min-conf/config/mode/"
                                        ;:ensure t
  :mode (("\\.h\\'" . qtcreator-mode)
         ("\\.hpp\\'" . qtcreator-mode)
         ("\\.cpp\\'" . qtcreator-mode))

  :config
  (message "qtcreator-mode activated")

  )
