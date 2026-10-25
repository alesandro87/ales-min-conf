;;; consult-config.el -*- lexical-binding: t; -*-
(use-package consult
  :ensure t
  ;; remap e non tasti: i remap locali dei mode (es. vterm-yank-pop) vincono
  :bind (([remap switch-to-buffer]              . consult-buffer)  ; C-x b
         ([remap switch-to-buffer-other-window] . consult-buffer-other-window)
         ([remap yank-pop]                      . consult-yank-pop) ; M-y
         ([remap goto-line]                     . consult-goto-line) ; M-g g
         ([remap imenu]                         . consult-imenu)    ; M-g i
         ("M-g f" . consult-flymake)
         ("M-s l" . consult-line))
  :custom
  (xref-show-xrefs-function #'consult-xref)
  (xref-show-definitions-function #'consult-xref))

(provide 'consult-config)
