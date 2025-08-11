;;; linux.el --- Configurazioni specifiche Linux -*- lexical-binding: t; -*-

;; font per linux
(set-face-attribute 'default nil 
                    :family "Fira Code"
                    ;;:family "DejaVu Sans Mono"
                    :height 100)
;;
(setq org-agenda-files '("/home/ales/Work/Note"))

;; (set-face-attribute 'default nil 
;;                     :family "JetBrains Mono"
;;                     :height 110)

;;Adatta al tuo username
(setq defaulte-directorfy "/home/ales/Work/")
;;;

(use-package vterm
  :ensure t
  :commands vterm
  :config
  (setq vterm-shell "/bin/zsh")
  (setq vterm-keymap-exceptions nil)
  ;;Scorciatoia: Ctrl-c t apre vterm
  (global-set-key (kbd "C-c t") #'vterm))
