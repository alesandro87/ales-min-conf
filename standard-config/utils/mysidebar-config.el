(defun my/toggle-left-padding (&optional width)
  "Apre/chiude una finestra vuota a sinistra come margine."
  (interactive)
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
        (display-buffer-in-side-window
         buf
         `((side . left)
           (slot . -1)
           (window-width . ,width)))))))

                                        ;   dmap-global-set "M-9" #'my/toggle-left-padding )
(keymap-global-set "M-9" (lambda () (interactive) (my/toggle-left-padding 40)))
(keymap-global-set "M-8" (lambda () (interactive) (my/toggle-left-padding 20)))

(provide 'mysidebar-config)
