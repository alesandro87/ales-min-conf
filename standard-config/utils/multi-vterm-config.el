(use-package multi-vterm
  :ensure t
  :bind (("C-c v t" . multi-vterm)
         ("C-c v n" . multi-vterm-next)
         ("C-c v p" . multi-vterm-prev)
         ("C-c v d" . multi-vterm-dedicated-toggle)
         ("C-c v o" . multi-vterm-dedicated-open)
         ("C-c v c" . multi-vterm-dedicated-close)
         ("C-c v r" . multi-vterm-project))   ;; r = root del progetto
  :custom
  (multi-vterm-dedicated-window-height 30))

(provide 'multi-vterm-config)
