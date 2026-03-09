;;; linux.el --- Configurazioni specifiche Linux -*- lexical-binding: t; -*-

;; usefull for load path zshrc or bashrc
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; font per linux
(set-face-attribute 'default nil 
                    :family "Hack"
                    ;;:family "DejaVu Sans Mono"
                    :height 110)

;; Font adattivo ai DPI del monitor
;; (defun my/font-size-from-display ()
;;   "Calcola font size ottimale dai DPI reali del display."
;;   (let* ((attrs (car (display-monitor-attributes-list)))
;;          (geom  (alist-get 'geometry attrs))
;;          (mm    (alist-get 'mm-size attrs))
;;          (dpi   (when (and geom mm
;;                            (car mm)
;;                            (> (car mm) 0))
;;                   (round (/ (* (caddr geom) 25.4)
;;                             (car mm))))))
;;     (if dpi
;;         (max 90 (round (* dpi 1.0)))
;;       100)))
;; 
;; (defun my/apply-font (&optional frame)
;;   (when (display-graphic-p)
;;     (set-face-attribute 'default nil
;;                         :family "Hack"
;;                         :height (my/font-size-from-display))))
;; 
;; (my/apply-font)
;; (add-hook 'after-make-frame-functions #'my/apply-font)
;; (add-hook 'window-size-change-functions (lambda (_) (my/apply-font)))

;;
(setq org-agenda-files '("/home/ales/Work/Note"))

;; (set-face-attribute 'default nil 
;;                     :family "JetBrains Mono"
;;                     :height 110)

;;Adatta al tuo username
(setq defaulte-directorfy "/home/ales/Work/")
;;;

;; (use-package vterm
;;   :ensure t
;;   :commands vterm
;;   :config
;;   (setq vterm-shell "/bin/zsh")
;;   (setq vterm-keymap-exceptions nil)
;;   ;;Scorciatoia: Ctrl-c t apre vterm
;;   (global-set-key (kbd "C-c t") #'vterm))

(provide 'linux)
