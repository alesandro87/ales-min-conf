;;; standard-config.el --- starting point for standard daily use configuration

(add-to-list 'load-path (expand-file-name "./ales-min-conf/standard-config/single" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "./ales-min-conf/standard-config/programming" user-emacs-directory))

(require 'ales-config)
(require 'eglot-config)

(provide 'standard-config)

