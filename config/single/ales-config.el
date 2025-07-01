;;; ales-config.el -- single configuration

;; Configurazioni UI comuni
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore)
(global-display-line-numbers-mode 1)
(column-number-mode 1)

;; Versione per terminale MSYS
(if (getenv "MSYSTEM")
    (custom-set-faces
     '(line-number ((t (:foreground "brightblack"))))
     '(line-number-current-line ((t (:foreground "white" :weight bold)))))
  ;; Versione per GUI Windows
  (custom-set-faces
   '(line-number ((t (:foreground "#a1a1aa" 
                                  :background "#f4f4f5"))))
   '(line-number-current-line ((t (:foreground "#71717a" 
                                               :background "#e4e4e7"))))))

;; custom shortcut
(global-set-key (kbd "C-c e") 'eshell)

;; example function
(defun erik()
  (interactive)
  (message "ciao"))

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

