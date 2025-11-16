
;; (with-eval-after-load 'eglot
;;   (add-to-list 'eglot-server-programs
;;                '((c++-ts-mode c-ts-mode) . ("clangd" "--compile-commands-dir=build-arm"))))

;; Hook per C++
(defun my-cpp-mode-hook ()
  "Hook personalizzato per C++"
  (eglot-ensure)
  (electric-pair-mode 1)
                                        ;(my-cpp-eglot-config)

  ;; clang format when save c++ file
  (add-hook 'before-save-hook  #'clang-format-buffer nil t)
  
  ;; Keybindings specifici per C++
  (local-set-key (kbd "C-c C-c") 'compile)
  (local-set-key (kbd "C-c C-r") 'recompile)
  (local-set-key (kbd "C-c m") 'man))

(add-hook 'c++-ts-mode-hook 'my-cpp-mode-hook)
(add-hook 'c-ts-mode-hook 'my-cpp-mode-hook)

(defun my-go-mode-hook()
  (eglot-ensure)
  (electric-pair-mode 1))

(add-hook 'go-mode 'my-go-mode-hook)

;; hook for org-mode
(add-hook 'org-mode-hook (lambda ()                                                 
                           (setq-local completion-at-point-functions                
                                       (list #'cape-dabbrev     ; Parole già scritte
                                             #'cape-file        ; Percorsi file     
                                             #'cape-dict        ; Dizionario parole 
                                             ;; #'cape-emoji                        
                                             ))))                                   




(provide 'programming-integrations)
