;;; linux.el --- Configurazioni specifiche Linux -*- lexical-binding: t; -*-
;; usefull for load path zshrc or bashrc
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; Usa Fira Code se disponibile, altrimenti DejaVu Sans Mono come fallback.
;; NB: font-family-list funziona solo con un frame grafico, quindi NON va
;; chiamata a load-time (specie col daemon). La agganciamo alla creazione frame.
(defun my/setup-font (&optional frame)
  "Imposta il font preferito su FRAME (o quello selezionato)."
  (when (display-graphic-p frame)
    (with-selected-frame (or frame (selected-frame))
      (let ((preferred-font
             (cond
              ((member "Fira Code" (font-family-list)) "Fira Code")
              ((member "JetBrains Mono" (font-family-list)) "JetBrains Mono")
              ((member "DejaVu Sans Mono" (font-family-list)) "DejaVu Sans Mono")
              (t "monospace"))))
        (set-face-attribute 'default nil :family preferred-font :height 110)
        (add-to-list 'default-frame-alist
                     `(font . ,(concat preferred-font "-11")))))))

;; Daemon: ogni nuovo frame da emacsclient
(add-hook 'after-make-frame-functions #'my/setup-font)
;; Avvio non-daemon: il frame iniziale esiste già a fine init
(add-hook 'window-setup-hook #'my/setup-font)

(setq-default line-spacing 2)

(provide 'linux)
