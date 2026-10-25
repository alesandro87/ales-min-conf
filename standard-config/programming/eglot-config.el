;;; eglot-config.el --- Configurazione di base per eglot -*- lexical-binding: t; -*-

;;; Commentary:
;; Impostazioni di eglot, tasti in `eglot-mode-map' e imenu dettagliato
;; costruito dai DocumentSymbol del server.

;;; Code:

(use-package eglot
  :ensure t
  :config
  ;; Ottimizzazioni generali per performance
  (setq eglot-events-buffer-config '(:size 0 :format full)) ; niente log degli eventi
  (setq eglot-sync-connect nil)
  (setq eglot-connect-timeout 10)
  (setq eglot-autoshutdown t)
  (setq eglot-send-changes-idle-time 0.2)

  ;; Disabilita solo la formattazione automatica mentre si scrive.  Le
  ;; capability di formattazione di documento e regione restano: senza,
  ;; eglot-format (C-c f) darebbe errore, e così la formattazione al
  ;; salvataggio di c-config.el (auto-format-on-save).
  (setq eglot-ignored-server-capabilities
        '(:documentOnTypeFormattingProvider))
  
  ;; Configurazione generale per tutti i linguaggi
  ;; (setq eglot-workspace-configuration
  ;;       '((nil . ((formatting . ((tabSize . 4)
  ;;                               (insertSpaces . t)))))))
  
  :bind (:map eglot-mode-map
              ("C-c d" . eglot-find-declaration)
              ("C-c i" . eglot-find-implementation)
              ("C-c r" . eglot-rename)
              ("C-c f" . eglot-format)
              ("C-c a" . eglot-code-actions)
              ("M-RET" . eglot-code-action-quickfix)
              ;; ("C-c h" . eldoc-doc-buffer)
              ))

;;; Senza server `eglot-ensure' prova comunque a connettersi e lascia un
;;; avviso a ogni file aperto: così, dove il server manca (es. Windows),
;;; eglot resta spento senza errori.  `M-x eglot' resta disponibile.
(defun my/eglot-ensure-if-found (&rest programs)
  "Avvia eglot nel buffer corrente se c'è almeno uno dei PROGRAMS."
  (when (seq-some (lambda (p) (executable-find p t)) programs)
    (eglot-ensure)))

;;; -------------------------------------------------------------------
;;; imenu dettagliato via eglot/LSP (granularità in stile clangd)
;;;
;;; Vale per qualsiasi linguaggio gestito da eglot (C/C++, Go, Python,
;;; Rust, ...): chiede `textDocument/documentSymbol' al server e ne
;;; ricava un imenu con kind, tipo di ritorno e parametri colorati.
;;; Le facce e l'advice di rendering vivono in imenu-list-config.el.
;;; -------------------------------------------------------------------
(declare-function eglot--lsp-position-to-point "eglot")
(declare-function eglot--TextDocumentIdentifier "eglot")
(declare-function eglot-current-server "eglot")
(declare-function eglot-managed-p "eglot")
(declare-function jsonrpc-request "jsonrpc")
(defvar my/imenu-detail-max-width)      ; imenu-list-config.el

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

(add-hook 'eglot-managed-mode-hook #'my/eglot-use-detailed-imenu)

(provide 'eglot-config)
