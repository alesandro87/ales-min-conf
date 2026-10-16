;;; standard-config.el --- starting point for standard daily use configuration -*- lexical-binding: t; -*-

(let ((dir (file-name-directory (file-truename (or load-file-name buffer-file-name)))))
  (dolist (sub '("single" "programming" "utils" "mode"))
    (add-to-list 'load-path (expand-file-name sub dir))))

(require 'ales-config) ;; load ales configuration, custom shortcut and other simple thinks

(if (my/is-linux-p)
    (require 'linux))

(if (my/is-windows-p)
    (require 'windows))

(require 'utils-config) ;; load vertico orderless and marginalia
(require 'programming-config)

(provide 'standard-config)
