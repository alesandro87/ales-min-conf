(use-package imenu-list
  :ensure t
  :bind (("M-1" . imenu-list-smart-toggle))
  :config
  (setq imenu-list-focus-after-activation t
        imenu-list-auto-resize t
        imenu-list-position 'right)

  ;; Facce personalizzabili (M-x customize-face)
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

  ;; 1) Rendering: fonde la face di profondità sotto ai colori.
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

  ;; Dati: eglot/clangd con kind, colori, troncamento e cache.
  (with-eval-after-load 'eglot

    (defconst my/eglot--kind-prefix
      '((5 . "C") (23 . "S") (3 . "N") (10 . "E") (11 . "I")
        (6 . "ƒ") (12 . "ƒ") (9 . "ƒ")
        (8 . "○") (7 . "○") (13 . "○") (14 . "○") (22 . "○"))
      "Prefisso per LSP SymbolKind: classi, struct, namespace,
enum, interfacce; funzioni/metodi/costruttori; campi/variabili.")

    (defun my/eglot--imenu-label (name detail kind)
      "Compone l'etichetta: [kind] NAME  RETTYPE (PARAMS), colorata."
      (let* ((prefix (cdr (assq kind my/eglot--kind-prefix)))
             (head (if prefix
                       (concat (propertize prefix 'face 'my/imenu-kind-face)
                               " " name)
                     name)))
        (if (and detail (> (length detail) 0))
            (let* ((d (if (> (length detail) my/imenu-detail-max-width)
                          (concat (substring detail 0 (1- my/imenu-detail-max-width)) "…")
                        detail))
                   (idx     (string-match-p "(" d))
                   (rettype (if idx (string-trim (substring d 0 idx)) d))
                   (params  (if idx (substring d idx) "")))
              (concat head "  "
                      (propertize rettype 'face 'my/imenu-rettype-face)
                      (if (string-empty-p params) ""
                        (concat " " (propertize params 'face 'my/imenu-params-face)))))
          head)))

    (defun my/eglot--symbol-to-imenu (sym)
      "Converte un DocumentSymbol SYM in voce imenu colorata."
      (let* ((name     (plist-get sym :name))
             (detail   (plist-get sym :detail))
             (kind     (plist-get sym :kind))
             (children (append (plist-get sym :children) nil))
             (sel      (or (plist-get sym :selectionRange)
                           (plist-get sym :range)))
             (pos      (eglot--lsp-position-to-point (plist-get sel :start)))
             (label    (my/eglot--imenu-label name detail kind)))
        (if children
            (cons label
                  (cons (cons (concat "→ " label) pos)
                        (mapcar #'my/eglot--symbol-to-imenu children)))
          (cons label pos))))

    (defvar-local my/eglot--imenu-cache nil
      "Cache (TICK . INDEX) per evitare richieste LSP ripetute.")

    (defun my/eglot-imenu-detailed ()
      "`imenu-create-index-function' via eglot/clangd, con cache."
      (let ((tick (buffer-chars-modified-tick)))
        (if (and my/eglot--imenu-cache
                 (eq (car my/eglot--imenu-cache) tick))
            (cdr my/eglot--imenu-cache)
          (when-let ((server (eglot-current-server)))
            (let* ((resp (ignore-errors
                           (jsonrpc-request
                            server :textDocument/documentSymbol
                            (list :textDocument (eglot--TextDocumentIdentifier))
                            :timeout 2)))
                   (index (and resp
                               (mapcar #'my/eglot--symbol-to-imenu
                                       (append resp nil)))))
              (if index
                  (progn (setq my/eglot--imenu-cache (cons tick index))
                         index)
                ;; clangd lento o errore: tieni l'ultimo indice valido
                (cdr my/eglot--imenu-cache)))))))

    (defun my/eglot-use-detailed-imenu ()
      (when (eglot-managed-p)
        (setq-local imenu-create-index-function #'my/eglot-imenu-detailed)))

    (add-hook 'eglot-managed-mode-hook #'my/eglot-use-detailed-imenu)))

(provide 'imenu-list-config)
