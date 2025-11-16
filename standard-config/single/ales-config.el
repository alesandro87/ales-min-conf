;;; ales-config.el -- single configuration

;; display time in the modeline
(add-hook 'after-init-hook #'display-time-mode)

;; Enable `auto-save-mode' to prevent data loss. Use `recover-file' or
;; `recover-session' to restore unsaved changes.
(setq auto-save-default t)

(setq auto-save-interval 300)
(setq auto-save-timeout 30)

;; theme
;(mapc #'disable-theme custom-enabled-themes)  
;; (load-theme 'tango-dark t)  ; Load the built-in theme
;; (load-theme 'modus-operandi t)  ; Load the built-in theme
;(load-theme 'adwaita t)

(use-package monokai-pro-theme
  :ensure t
  :config
  (load-theme 'monokai-pro t))

;; autorevert permette il caricamento dei file
;; quando sono modificati
(global-auto-revert-mode 1)
;(electric-pair-mode t)
(setq text-scale-mode-step 1.05)  ; default è 1.2
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Configurazioni UI comuni
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore)
(global-display-line-numbers-mode 1)
(column-number-mode 1)

;; Versione per terminale MSYS (per tema chiaro)
;; (if (getenv "MSYSTEM")
;;     (custom-set-faces
;;      '(line-number ((t (:foreground "brightblack"))))
;;      '(line-number-current-line ((t (:foreground "white" :weight bold)))))
;;   ;; Versione per GUI Windows
;;   (custom-set-faces
;;    '(line-number ((t (:foreground "#a1a1aa" 
;;                                   :background "#f4f4f5"))))
;;    '(line-number-current-line ((t (:foreground "#71717a" 
;;                                                :background "#e4e4e7"))))))

;; Versione per terminale MSYS
(if (getenv "MSYSTEM")
    ;; Terminale: usa colori ANSI simili al Monokai Pro
    (custom-set-faces
     '(line-number ((t (:foreground "brightblack"))))
     '(line-number-current-line ((t (:foreground "white" :weight bold)))))
  ;; Versione per GUI Windows: palette Monokai Pro
  (custom-set-faces
   '(line-number ((t (:foreground "#5b6268"    ;; grigio spento
                                  :background "#2d2a2e")))) ;; fondo scuro
   '(line-number-current-line ((t (:foreground "#f92672"  ;; rosa acceso
                                               :background "#3e3b3f" 
                                               :weight bold))))))

;; custom shortcut
(global-set-key (kbd "C-c e") 'eshell)
;; dired
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "M-p") 'dired-up-directory))

;; example function
(defun erik()
  (interactive)
  (message "ciao"))

;;funzione per atanasio da francy
(defun funzioneFrancy ()
  (interactive)
  (message "Ciao Atanasio, che figata il lisp!")
  (let ((num (read-number "Inserisci un numero da 1 a 5: ")))
    (cond
     ((= num 1) (message "Mi devi un kit kat"))
     ((= num 2) (message "Pausa fra 10 min"))
     ((= num 3) (message "Hai vinto un caffè"))
     ((= num 4) (message "Hai 5 euro?"))
     ((= num 5) (message "PAUSAAAA ORA?!"))
     (t (message "Numero non valido, devi inserire da 1 a 5 COGLIONE")))))


;; you can select region and calculate the math operation
;; 1 + 1 = 2
(defmacro *-and-replace (function-name inner-function)
  `(defun ,function-name (begin end)
     (interactive "r")
     (let* ((input (buffer-substring-no-properties begin end))
            (output (funcall ,inner-function input)))
       ;;(delete-region begin end)
       (goto-char end)
       (insert (concat " = "
                       (if (stringp output) output
                         (format " %S" output)))))))

(*-and-replace calc-eval-region #'calc-eval)

(provide 'ales-config)
