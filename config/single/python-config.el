;;; python-config.el -- single configuration

;; Python mode avanzato
(use-package python-mode
  :ensure t
  :mode "\\.py\\'"
  :config
  (setq python-indent-offset 4))
