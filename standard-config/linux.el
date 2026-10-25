;;; linux.el --- Configurazioni specifiche Linux -*- lexical-binding: t; -*-
;; usefull for load path zshrc or bashrc
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; Il font (my/font-setup) è in ales-config.el, uguale per Linux e Windows.

(setq-default line-spacing 2)

(provide 'linux)
