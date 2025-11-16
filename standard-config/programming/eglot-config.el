;;; eglot-config.el --- Configurazione di base per eglot -*- lexical-binding: t; -*-

;;; Commentary:
;; Questo file contiene impostazioni personalizzate per Emacs.
;; Aggiungi qui le tue funzioni, hook e variabili.

;; (interactive)
;; (message "eglot config loaded")

(use-package eglot
  :ensure t
  :config
  ;; Ottimizzazioni generali per performance
  (setq eglot-events-buffer-size 0)
  (setq eglot-sync-connect nil)
  (setq eglot-connect-timeout 10)
  (setq eglot-autoshutdown t)
  (setq eglot-send-changes-idle-time 0.2)
  
  ;; Configurazione generale per tutti i linguaggi
  (setq eglot-workspace-configuration
        '((nil . ((formatting . ((tabSize . 4)
                                 (insertSpaces . t)))))))
  
  :bind (:map eglot-mode-map
              ;; ("<f4>" . projectile-find-other-file)
              ("C-c d" . eglot-find-declaration)
              ("C-c i" . eglot-find-implementation)
              ("C-c r" . eglot-rename)
              ("C-c f" . eglot-format)
              ("C-c a" . eglot-code-actions)
              ;; ("C-c h" . eldoc-doc-buffer)
              ;; ("C-c n" . flymake-goto-next-error)
              ;; ("C-c p" . flymake-goto-prev-error)))
              ))

(provide 'eglot-config)
