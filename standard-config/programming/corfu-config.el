(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)

  :custom
  (corfu-auto t)                 ; Completamento automatico
  (corfu-auto-delay 0.5)         ; Ritardo 0.5 secondi
  (corfu-auto-prefix 2)          ; Min 2 caratteri

  :bind
  (:map corfu-map
        ("TAB" . corfu-insert)     ; TAB per completare
        ([tab] . corfu-insert))     ; TAB alternativo
                                        ;("RET" . nil)              ; Disabilita completamento con Invio
                                        ;("<return>" . nil)
  
  
                                        ;("TAB" . corfu-next)
                                        ;("S-TAB" . corfu-previous)
                                        ;("TAB" . corfu-insert))

  ;;:hook (
  ;;       (prog-mode . corfu-mode)
  ;;       (markdown-mode . (lambda ()
  ;;                          (setq-local completion-at-point-functions
  ;;                                      (list #'cape-dabbrev     ; Parole già scritte
  ;;                                            #'cape-file        ; Percorsi file
  ;;                                            #'cape-dict        ; Dizionario parole
  ;;                                            ;; #'cape-emoji
  ;;                                            ))))
  ;;
  ;;       (org-mode . (lambda ()
  ;;                     (setq-local completion-at-point-functions
  ;;                                 (list #'cape-dabbrev     ; Parole già scritte
  ;;                                       #'cape-file        ; Percorsi file
  ;;                                       #'cape-dict        ; Dizionario parole
  ;;                                       ;; #'cape-emoji
  ;;                                       ))))
  ;;       )
  )

;; Add extensions
(use-package cape
  ;; Bind prefix keymap providing all Cape commands under a mnemonic key.
  ;; Press C-c p ? to for help.
  :bind ("C-c p" . cape-prefix-map) ;; Alternative key: M-<tab>, M-p, M-+
  ;; Alternatively bind Cape commands individually.
  ;; :bind (("C-c p d" . cape-dabbrev)
  ;;        ("C-c p h" . cape-history)
  ;;        ("C-c p f" . cape-file)
  ;;        ...)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  ;; (add-hook 'completion-at-point-functions #'cape-history)
  ;; ...
)


(provide 'corfu-config)
