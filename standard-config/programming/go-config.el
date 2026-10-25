;;; go-config.el -*- lexical-binding: t; -*-
(defvar gofmt-command)                  ; go-mode
(declare-function gofmt-before-save "go-mode")
(declare-function my/eglot-ensure-if-found "eglot-config" (&rest programs))

(defun my/go-setup ()
  "Eglot con gopls e formattazione al salvataggio, solo se i programmi ci sono."
  (my/eglot-ensure-if-found "gopls")
  ;; goimports se c'è, altrimenti gofmt (viene con Go), cercati sull'host
  ;; del file: go-mode lancia il formatter con `process-file' (anche sul
  ;; remoto) e poi `diff' in locale per applicare le modifiche
  (let ((formatter (seq-find (lambda (p) (executable-find p t))
                             '("goimports" "gofmt"))))
    (when (and formatter (executable-find "diff"))
      (setq-local gofmt-command formatter)
      (add-hook 'before-save-hook #'gofmt-before-save nil t))))

(defun my/go-run ()
  "Esegue `go run .' nella directory del file con `compile' (anche via TRAMP)."
  (interactive)
  (let ((default-directory (if buffer-file-name
                               (file-name-directory buffer-file-name)
                             default-directory)))
    (unless (executable-find "go" t)
      (user-error "go non trovato"))
    (compile "go run .")))

;; M-., M-? e M-, (xref, con eglot) sono già i tasti di default
(use-package go-mode
  :ensure t
  :hook (go-mode . my/go-setup)
  :bind (:map go-mode-map
              ("C-c m r" . my/go-run)))

;; hook per go
(with-eval-after-load 'eglot
  ;; Usa gopls per Go
  (add-to-list 'eglot-server-programs
               '(go-mode . ("gopls"))))

(provide 'go-config)
