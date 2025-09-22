;;; go-config.el -- single configuration for golang

(use-package go-mode
  :ensure t
  :hook ((go-mode . eglot-ensure)
         (before-save . gofmt-before-save))
  :config
  (setq gofmt-command "goimports"))

(with-eval-after-load 'eglot
  ;; Server per Go
  (add-to-list 'eglot-server-programs
               '(go-mode . ("gopls"))))


;; debug

;; Configurazione personalizzata per Go debugging
(with-eval-after-load 'dape
  ;; Template per debugging di applicazioni Go
  (add-to-list 'dape-configs
               `(go-debug-app
                 modes (go-mode)
                 ensure dape-ensure-command
                 command "dlv"
                 command-args ("dap" "--listen" "127.0.0.1::autoport")
                 command-cwd dape-cwd-fn
                 port :autoport
                 :request "launch"
                 :type "debug"
                 :program "."
                 :args []
                 :buildFlags ["-gcflags=all=-N -l"]))  ; Disabilita ottimizzazioni
  
  ;; Template per debugging di test
  (add-to-list 'dape-configs
               `(go-debug-test
                 modes (go-mode)
                 ensure dape-ensure-command
                 command "dlv"
                 command-args ("dap" "--listen" "127.0.0.1::autoport")
                 command-cwd dape-cwd-fn
                 port :autoport
                 :request "launch"
                 :type "debug"
                 :mode "test"
                 :program ".")))

(defun go-debug-current-file ()
  "Debug del file Go corrente usando dape."
  (interactive)
  (if (derived-mode-p 'go-mode)
      (let* ((file (buffer-file-name))
             (dir (file-name-directory file)))
        (dape `(dlv exec ,file)))
    (message "Non in un buffer go-mode")))

(defun go-debug-current-test ()
  "Debug del test corrente."
  (interactive)
  (if (and (derived-mode-p 'go-mode)
           (string-match "_test\\.go$" (buffer-name)))
      (dape 'go-debug-test)
    (message "Non in un file di test Go")))

(defun go-run-test-at-point ()
  "Esegue il test alla posizione del cursore."
  (interactive)
  (when (derived-mode-p 'go-mode)
    (let ((test-name (which-function)))
      (if test-name
          (compile (format "go test -run ^%s$ ." test-name))
        (message "Nessun test trovato al punto corrente")))))

