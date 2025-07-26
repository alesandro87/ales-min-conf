;;; qtcreator-config.el -- single configuration

(require 'use-package)

(use-package qtcreator-mode
  :load-path "~/.emacs.d/ales-min-conf/config/mode/"
  ;:ensure t
  :mode (("\\.h\\'" . qtcreator-mode)
         ("\\.hpp\\'" . qtcreator-mode)
         ("\\.cpp\\'" . qtcreator-mode))

  :config
  (message "qtcreator-mode activated")

  )
