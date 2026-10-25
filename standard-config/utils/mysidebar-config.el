;;; mysidebar-config.el -*- lexical-binding: t; -*-
(defun my/toggle-left-padding (&optional width)
  "Apre/chiude una finestra vuota a sinistra larga WIDTH colonne come margine.
WIDTH è il prefisso numerico; senza, 20."
  (interactive (list (and current-prefix-arg
                          (prefix-numeric-value current-prefix-arg))))
  (setq width (or width 20))
  (unless (> width 0)
    (user-error "Larghezza non valida: %d" width))
  (let ((padding-buf-name " *left-padding*"))
    (if-let ((win (get-buffer-window padding-buf-name)))
        (delete-window win)
      (let ((buf (get-buffer-create padding-buf-name)))
        (with-current-buffer buf
          (setq-local mode-line-format nil)
          (setq-local cursor-type nil)
          (setq-local truncate-lines t)
          (setq-local window-size-fixed 'width)
          (setq-local left-margin-width 0)
          (setq-local right-margin-width 0)
          (read-only-mode 1))
        (let ((win (display-buffer-in-side-window
                    buf
                    `((side . left)
                      (slot . -1)
                      (window-width . ,width)))))
          (set-window-parameter win 'no-other-window t))))))

(defun my/toggle-left-padding-40 ()
  "Apre/chiude il margine sinistro di 40 colonne."
  (interactive)
  (my/toggle-left-padding 40))

(defun my/toggle-left-padding-20 ()
  "Apre/chiude il margine sinistro di 20 colonne."
  (interactive)
  (my/toggle-left-padding 20))

(defun my/toggle-left-padding-10 ()
  "Apre/chiude il margine sinistro di 10 colonne."
  (interactive)
  (my/toggle-left-padding 10))

(keymap-global-set "M-9" #'my/toggle-left-padding-40)
(keymap-global-set "M-8" #'my/toggle-left-padding-20)
(keymap-global-set "M-7" #'my/toggle-left-padding-10)

(provide 'mysidebar-config)
