;;; corfu-config.el -*- lexical-binding: t; -*-
(use-package corfu
  :ensure t
  ;; text-mode copre anche Org e Markdown
  :hook ((prog-mode . corfu-mode)
         (text-mode . corfu-mode))
  :custom
  (corfu-auto t)                 ; Completamento automatico
  (corfu-auto-delay 0.5)         ; Ritardo 0.5 secondi
  (corfu-auto-prefix 2)          ; Min 2 caratteri
  ;; TAB inserisce il candidato (corfu lo lega a corfu-complete); in GUI il
  ;; tasto <tab> ricade su TAB
  :bind (:map corfu-map
              ("TAB" . corfu-insert)))

;; Emacs 30 non ha child frame su TTY: corfu-terminal disegna il popup
;; con popon nei frame testuali (emacs-nox, emacsclient -t); nei frame
;; grafici resta il child frame.  Da Emacs 31 non serve più.
(use-package corfu-terminal
  :ensure t
  :if (< emacs-major-version 31)
  :after corfu
  :config
  (corfu-terminal-mode 1))

;; Add extensions
(use-package cape
  :ensure t
  ;; Bind prefix keymap providing all Cape commands under a mnemonic key.
  ;; Press M-+ ? for help.  Non C-c p: è il prefisso delle ricerche nel
  ;; progetto (project-config.el).
  :bind ("M-+" . cape-prefix-map)
  :init
  ;; Add to the global default value of `completion-at-point-functions' which is
  ;; used by `completion-at-point'.  The order of the functions matters, the
  ;; first function returning a result wins.  Note that the list of buffer-local
  ;; completion functions takes precedence over the global list.
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(provide 'corfu-config)
