;;; linux.el --- Configurazioni specifiche Linux -*- lexical-binding: t; -*-

;; usefull for load path zshrc or bashrc
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; font per linux
(set-face-attribute 'default nil 
                    :family "Fira Code"
                    ;;:family "DejaVu Sans Mono"
                    :height 110)
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
