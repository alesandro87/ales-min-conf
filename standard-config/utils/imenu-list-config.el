(use-package imenu-list
  :ensure t
  :bind (("M-1" . imenu-list-smart-toggle))
  :config
  (setq imenu-list-focus-after-activation t
        imenu-list-auto-resize t
        imenu-list-position 'right)

  ;; Facce personalizzabili (M-x customize-face). Condivise da tutti i
  ;; backend imenu dettagliati (eglot, common lisp, ...).
  (defface my/imenu-rettype-face
    '((t :inherit font-lock-type-face))
    "Faccia per il tipo di ritorno nel pannello imenu-list.")

  (defface my/imenu-params-face
    '((t :inherit font-lock-variable-name-face))
    "Faccia per i parametri formali nel pannello imenu-list.")

  (defface my/imenu-kind-face
    '((t :inherit font-lock-keyword-face))
    "Faccia per il prefisso del tipo di simbolo (ƒ, C, ○...).")

  (defcustom my/imenu-detail-max-width 40
    "Larghezza massima della firma prima del troncamento con `…'."
    :type 'integer)

  ;; Rendering: fonde la face di profondità sotto ai colori per-carattere.
  (defun my/imenu-list--insert-entry (entry depth)
    "Come `imenu-list--insert-entry', ma conserva le face per-carattere."
    (let* ((subalistp (imenu--subalist-p entry))
           (name (car entry))
           (label (if subalistp (concat "+ " name) name))
           start end)
      (insert (imenu-list--depth-string depth))
      (setq start (point))
      (insert-text-button
       label
       'help-echo (format (if subalistp "Toggle: %s" "Go to: %s") name)
       'follow-link t
       'action (if subalistp
                   #'imenu-list--action-toggle-hs
                 #'imenu-list--action-goto-entry))
      (setq end (point))
      (add-face-text-property start end
                              (imenu-list--get-face depth subalistp) t)
      (insert "\n")))
  (advice-add 'imenu-list--insert-entry :override #'my/imenu-list--insert-entry))

(provide 'imenu-list-config)
