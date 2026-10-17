;;; windows.el --- Configurazioni specifiche Windows -*- lexical-binding: t; -*-

;; only for windows start server
; (server-start)

;; Usa Fira Code o Cascadia Mono (default di Windows 11) se disponibili,
;; altrimenti Consolas. Come in linux.el: font-family-list funziona solo con un
;; frame grafico, quindi la agganciamo alla creazione del frame.
(defun my/setup-font-windows (&optional frame)
  "Imposta il font preferito su FRAME (o quello selezionato)."
  (when (display-graphic-p frame)
    (with-selected-frame (or frame (selected-frame))
      (let ((preferred-font
             (cond
              ((member "Fira Code" (font-family-list)) "Fira Code")
              ((member "Cascadia Mono" (font-family-list)) "Cascadia Mono")
              (t "Consolas"))))
        (set-face-attribute 'default (selected-frame) :family preferred-font :height 120)
        (add-to-list 'default-frame-alist
                     `(font . ,(concat preferred-font "-12")))))))

(add-hook 'after-make-frame-functions #'my/setup-font-windows)
(add-hook 'window-setup-hook #'my/setup-font-windows)

;; Path per Windows
;;(when (executable-find "git")
;;  (setq magit-git-executable (executable-find "git")))

;; Browser su Windows
;; (setq browse-url-browser-function 'browse-url-default-windows-browser)

;; Configurazioni specifiche Windows
(setq w32-pass-alt-to-system nil)

;; Avviato da un collegamento, Emacs parte nella sua cartella di
;; installazione: meglio la home dell'utente.
(when-let ((home (getenv "USERPROFILE")))
  (setq default-directory (file-name-as-directory home)))

;; vterm non funziona su Windows nativo (multi-vterm-config non viene
;; caricato): C-c v t apre eshell al suo posto.
(global-set-key (kbd "C-c v t") #'eshell)

(provide 'windows)
