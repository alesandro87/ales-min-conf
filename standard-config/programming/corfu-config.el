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

  :hook (
         (prog-mode . corfu-mode)
         (markdown-mode . (lambda ()
                            (setq-local completion-at-point-functions
                                        (list #'cape-dabbrev     ; Parole già scritte
                                              #'cape-file        ; Percorsi file
                                              #'cape-dict        ; Dizionario parole
                                              ;; #'cape-emoji
                                              ))))

         (org-mode . (lambda ()
                       (setq-local completion-at-point-functions
                                   (list #'cape-dabbrev     ; Parole già scritte
                                         #'cape-file        ; Percorsi file
                                         #'cape-dict        ; Dizionario parole
                                         ;; #'cape-emoji
                                         ))))
         )
  )


(provide 'corfu-config)
