(defun diredsidebar-config/visible-line-width ()
  "Larghezza display della riga corrente, ignorando il testo invisibile."
  (let ((width 0)
        (pos (line-beginning-position))
        (end (line-end-position)))
    (while (< pos end)
      (let ((next (or (next-single-property-change pos 'invisible nil end) end)))
        (unless (invisible-p pos)
          (setq width (+ width (string-width
                                (buffer-substring-no-properties pos next)))))
        (setq pos next)))
    width))

(defun diredsidebar-config/max-line-width ()
  "Colonna visibile massima nel buffer."
  (save-excursion
    (goto-char (point-min))
    (let ((max 0))
      (while (not (eobp))
        (setq max (max max (diredsidebar-config/visible-line-width)))
        (forward-line 1))
      max)))

(defun diredsidebar-config/fit-width (&optional buffer)
  "Adatta la larghezza della sidebar al file più lungo, mai oltre 45 colonne."
  (with-current-buffer (or buffer (current-buffer))
    (when (bound-and-true-p dired-sidebar-mode)
      (let ((win (get-buffer-window (current-buffer))))
        (when (window-live-p win)
          (let* ((content (diredsidebar-config/max-line-width))
                 (target  (min 50 (+ content 2)))   ; "poco più" = +2
                 (delta   (- target (window-width win)))
                 (window-size-fixed nil))
            (window-resize win delta t t)))))))     ; t finale = ignora size-fixed

(defun diredsidebar-config/refit (&rest _)
  "Wrapper per advice/hook."
  (diredsidebar-config/fit-width))

(defun diredsidebar-config/fit-on-open ()
  "Ricalcola la larghezza dopo che la finestra è renderizzata."
  (let ((buf (current-buffer)))
    (run-at-time 0 nil #'diredsidebar-config/fit-width buf)))

(defun diredsidebar-config/space-pressed ()
  "Toggle del sottoalbero se è una directory, altrimenti apre il file."
  (interactive)
  (if (file-directory-p (dired-get-file-for-visit))
      (dired-sidebar-subtree-toggle)   ; il fit lo fa l'advice
    (dired-sidebar-find-file)))

(use-package dired-sidebar
  :bind (("M-0" . dired-sidebar-toggle-sidebar)
       :map dired-sidebar-mode-map
       ("SPC" . diredsidebar-config/space-pressed)
       ("<tab>" . dired-sidebar-subtree-toggle)
       ("<backtab>" . dired-sidebar-subtree-cycle))
  :config
  ;; aspetto
  (setq dired-sidebar-width 30)  ; solo valore iniziale, poi ricalcolato
  (setq dired-sidebar-subtree-line-prefix "  ")
  (setq dired-sidebar-theme 'ascii)
  (setq dired-sidebar-use-term-integration nil)
  (setq dired-sidebar-use-custom-font nil)
  ;; ordinamento
  (setq dired-listing-switches "-alh --group-directories-first")
  ;; comportamento
  (setq dired-sidebar-follow-file t)
  (setq dired-sidebar-pop-to-sidebar-on-toggle-open t)
  ;; larghezza dinamica
  (advice-add 'dired-sidebar-subtree-toggle :after #'diredsidebar-config/refit)
  (advice-add 'dired-sidebar-subtree-cycle  :after #'diredsidebar-config/refit)
  (add-hook 'dired-sidebar-mode-hook #'diredsidebar-config/fit-on-open)
  ;; look minimal
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (hl-line-mode 1)
              (display-line-numbers-mode -1)
              (setq-local truncate-lines t)
              (setq-local window-size-fixed 'width)
              (setq-local cursor-type nil)
              (setq-local left-margin-width 1))))
(provide 'diredsidebar-config)
