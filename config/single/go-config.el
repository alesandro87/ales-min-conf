;;; go-config.el --- Configurazione Go + Debug con dape

(use-package go-mode
  :ensure t
  :hook ((go-mode . eglot-ensure)
         (before-save . gofmt-before-save))

  :bind (:map go-mode-map
              ("M-?" . xref-find-references)
              ("M-." . xref-find-definitions)
              ("M-," . xref-pop-marker-stack)
              ;; ("M-*" . pop-tag-mark) ;; Jump back after godef-jump
              ("C-c m r" . go-run))
  :config
  (setq gofmt-command "goimports"))

(with-eval-after-load 'eglot
  ;; Usa gopls per Go
  (add-to-list 'eglot-server-programs
               '(go-mode . ("gopls"))))

;; (with-eval-after-load 'dape
;;   ;; Debug configuration semplificata per Go
;;   (add-to-list 'dape-configs
;;                `(delve-go
;;                  modes (go-mode go-ts-mode)
;;                  command "dlv"
;;                  command-args ("dap" "--listen" "127.0.0.1:55878")
;;                  command-cwd dape-cwd-fn
;;                  port :autoport
;;                  :request "launch"
;;                  :type "go"
;;                  :name "Launch Package"
;;                  :mode "debug"
;;                  :program dape-cwd-fn
;;                  :args []))
;;   
;;   ;; Configurazione per progetti con struttura cmd/
;;   (add-to-list 'dape-configs
;;                `(delve-go-cmd
;;                  modes (go-mode go-ts-mode) 
;;                  command "dlv"
;;                  command-args ("dap" "--listen" "127.0.0.1:55878")
;;                  command-cwd ,(lambda () (project-root (project-current)))
;;                  port :autoport
;;                  :request "launch"
;;                  :type "go"
;;                  :name "Launch Package"
;;                  :mode "debug"
;;                  :program ,(lambda ()
;;                              (let* ((current-file (buffer-file-name))
;;                                     (file-dir (file-name-directory current-file))
;;                                     (project-root (project-root (project-current))))
;;                                (file-relative-name file-dir project-root)))
;;                  :args [])))
;; 
