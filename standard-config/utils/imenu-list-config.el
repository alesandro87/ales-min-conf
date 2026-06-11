(use-package imenu-list
  :ensure t
  :bind (("M-1" . imenu-list-smart-toggle))
  :config
  (setq imenu-list-focus-after-activation t
        imenu-list-auto-resize t
        imenu-list-position 'right)

  
  ;; Rendering: fonde la face di profondità SOTTO ai colori già
  ;; presenti sull'etichetta, invece di sovrascriverli.
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
  (advice-add 'imenu-list--insert-entry :override #'my/imenu-list--insert-entry)

  
  ;; Dati: eglot + clangd, con tipo di ritorno e parametri colorati.
  (with-eval-after-load 'eglot
    (defun my/eglot--imenu-label (name detail)
      "Compone NAME + DETAIL, colorando tipo di ritorno e parametri."
      (if (and detail (> (length detail) 0))
          (let* ((idx     (string-match-p "(" detail))
                 (rettype (if idx (string-trim (substring detail 0 idx)) detail))
                 (params  (if idx (substring detail idx) "")))
            (concat name "   "
                    (propertize rettype 'face 'font-lock-type-face)
                    (if (string-empty-p params) ""
                      (concat " " (propertize params
                                              'face 'font-lock-variable-name-face)))))
        name))

    (defun my/eglot--symbol-to-imenu (sym)
      "Converte un DocumentSymbol SYM in voce imenu con etichetta colorata."
      (let* ((name     (plist-get sym :name))
             (detail   (plist-get sym :detail))
             (children (append (plist-get sym :children) nil))
             (sel      (or (plist-get sym :selectionRange)
                           (plist-get sym :range)))
             (pos      (eglot--lsp-position-to-point (plist-get sel :start)))
             (label    (my/eglot--imenu-label name detail)))
        (if children
            (cons label
                  (cons (cons (concat "→ " label) pos)
                        (mapcar #'my/eglot--symbol-to-imenu children)))
          (cons label pos))))

    (defun my/eglot-imenu-detailed ()
      "`imenu-create-index-function' basato su eglot/clangd."
      (when-let ((server (eglot-current-server)))
        (let ((resp (jsonrpc-request
                     server :textDocument/documentSymbol
                     (list :textDocument (eglot--TextDocumentIdentifier)))))
          (mapcar #'my/eglot--symbol-to-imenu (append resp nil)))))

    (defun my/eglot-use-detailed-imenu ()
      (when (eglot-managed-p)
        (setq-local imenu-create-index-function #'my/eglot-imenu-detailed)))

    (add-hook 'eglot-managed-mode-hook #'my/eglot-use-detailed-imenu)))

(provide 'imenu-list-config)
