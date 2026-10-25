;;; ales-config.el --- single configuration -*- lexical-binding: t; -*-

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

;; (use-package monokai-pro-theme
;;   :ensure t
;;   :config
;;   (load-theme 'monokai-pro t))

(use-package modus-themes
  :ensure t
  :config
  (load-theme 'modus-vivendi t))
  ;;(load-theme 'modus-vivendi-tinted t))

;; autorevert permette il caricamento dei file
;; quando sono modificati
(global-auto-revert-mode 1)
(setq text-scale-mode-step 1.05)  ; default è 1.2
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Configurazioni UI comuni (schermata iniziale e campanello li spegne
;; già minimal-emacs.d)
;; Numeri di riga nei mode di codice, testo e configurazione (e derivati),
;; non in vterm, eshell, ibuffer, dired, help...
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))
;; Parentesi automatiche solo nel codice, non in Org, Markdown e testo
(add-hook 'prog-mode-hook #'electric-pair-local-mode)
(column-number-mode 1)

;; Font, uguale su Linux e Windows: il primo installato della lista.
;; font-family-list funziona solo su un frame grafico, quindi niente
;; chiamate a load-time: si aggancia alla creazione dei frame (daemon) e a
;; window-setup-hook (avvio normale, il frame iniziale esiste già).
(defvar my/font-families
  '("Fira Code" "JetBrains Mono" "Cascadia Mono" "DejaVu Sans Mono" "Consolas")
  "Font preferiti in ordine; si usa il primo installato.")

(defvar my/font--emoji-done nil
  "Non nil quando il font emoji è già nel fontset predefinito.")

(defun my/font-setup (&optional frame)
  "Imposta font e dimensione su FRAME (o quello selezionato), se grafico.
La prima volta che il font emoji è disponibile lo aggiunge al fontset
predefinito, che vale per tutti i frame."
  (let ((frame (or frame (selected-frame))))
    (when (display-graphic-p frame)
      (let* ((families (font-family-list frame))
             (installed (lambda (f) (member f families)))
             (font (seq-find installed my/font-families))
             (emoji (seq-find installed '("Noto Color Emoji" "Segoe UI Emoji"))))
        (if font
            (progn
              (set-face-attribute 'default frame :family font :height 120)
              (setf (alist-get 'font default-frame-alist) (concat font "-12")))
          (set-face-attribute 'default frame :height 120))
        (when (and emoji (not my/font--emoji-done))
          (set-fontset-font t 'emoji emoji nil 'prepend)
          (setq my/font--emoji-done t))))))

(add-hook 'after-make-frame-functions #'my/font-setup)
(add-hook 'window-setup-hook #'my/font-setup)

;; custom shortcut
(global-set-key (kbd "C-c e") 'eshell)
;; dired
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "M-<up>") 'dired-up-directory))

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
(defmacro my/define-region-evaluator (function-name inner-function)
  `(defun ,function-name (begin end)
     (interactive "r")
     (let* ((input (buffer-substring-no-properties begin end))
            (output (funcall ,inner-function input)))
       ;;(delete-region begin end)
       (goto-char end)
       (insert (concat " = "
                       (if (stringp output) output
                         (format " %S" output)))))))

(my/define-region-evaluator my/calc-eval-region #'calc-eval)

(provide 'ales-config)
