;;; standard-config.el --- starting point for standard daily use configuration

(add-to-list 'load-path (expand-file-name "./ales-min-conf/standard-config/single" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "./ales-min-conf/standard-config/programming" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "./ales-min-conf/standard-config/utils" user-emacs-directory))

(require 'ales-config) ;; load ales configuration, custom shortcut and other simple thinks
(require 'utils-config) ;; load vertico orderless and marginalia
(require 'programming-config) 


(provide 'standard-config)
