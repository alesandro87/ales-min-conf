(use-package org
  :ensure t
  :defer t
  :commands (org-mode org-version)
  :mode
  ("\\.org\\'" . org-mode)

  :bind
  (("M-o" . org-search-view))

  :config
  ;; AGGIUNTA: carica moduli per i grafici Org
                                        ;(require 'ob-gnuplot)
  (require 'gnuplot)
  (require 'org-plot)

  ;; AGGIUNTA: abilita il linguaggio gnuplot in Org Babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((gnuplot . t)))

  :config
  ;; load the correct path
  ;; (setq org-agenda-files (directory-files-recursively "C:\\Users\\atanasio\\Work\\Note" "\\.org$"))
  (cond
   ((eq system-type 'windows-nt)
    (setq org-agenda-files (directory-files-recursively "C:\\Users\\atanasio\\Work\\Note" "\\.org$")))
   ((eq system-type 'gnu/linux)
    (setq org-agenda-files (directory-files-recursively "~/Work/Note/" "\\.org$")))
   ;;(setq org-agenda-files (directory-files-recursively "~/Work/Note/Elen/Sprint/" "\\.org$")))
   ((eq system-type 'darwin)  ; macOS
    (setq org-agenda-files (directory-files-recursively "~/Work/Note/" "\\.org$"))))
  
  ;; La tua funzione per pulire le righe vuote
  (defun clear-double-return ()
    "Rimuove righe vuote multiple lasciandone solo una"
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "\n\n+" nil t)
        (replace-match "\n\n"))))

  (setq org-todo-keywords
        '((sequence "TODO(t)" "IN_PROGRESS(p)" "DONE(d)")))
  
  (setq org-todo-keyword-faces
        '(("TODO" . (:foreground "hot pink" :weight bold))
          ("IN_PROGRESS" . (:foreground "yellow" :weight bold))
          ;; ("WAITING" . (:foreground "orange" :weight bold))
          ;; ("REVIEW" . (:foreground "cyan" :weight bold))
          ("DONE" . (:foreground "green" :weight bold))
          ;; ("CANCELLED" . (:foreground "red" :weight bold)
          ))
  
  ;; Configurazione font per emoji
  (set-fontset-font t 'symbol 
                    (cond
                     ((eq system-type 'windows-nt) "Segoe UI Emoji")
                     ((eq system-type 'darwin) "Apple Color Emoji")
                     ((eq system-type 'gnu/linux) "Noto Color Emoji"))
                    nil 'prepend)
  
  ;; :hook(
  ;;       ((org-mode . (lambda ()
  ;;                      (setq-local prettify-symbols-alist
  ;;                                  '(("lambda" . ?λ)
  ;;                                       ;("->" . ?→)
  ;;                                    ("map" . ?↦)
  ;;                                    ("/=" . ?≠)
  ;;                                    ("!=" . ?≠)
  ;;                                    ("==" . ?≡)
  ;;                                    ("<=" . ?≤)
  ;;                                    (">=" . ?≥)
  ;;                                    ("&&" . ?∧)
  ;;                                    ("||" . ?∨)
  ;;                                    ("sqrt" . ?√)
  ;;                                       ;("..." . ?…)
  ;;                                    ))
  ;;                      (prettify-symbols-mode 1)
  ;;                      (visual-line-mode 1)
  ;;                      (face-remap-add-relative 'bold :foreground "magenta")))))

  :custom
  (org-hide-leading-stars t)
  (org-startup-indented t)
  (org-adapt-indentation nil)
  (org-edit-src-content-indentation 0)
  (org-startup-truncated nil)
  (org-fontify-done-headline t)
  (org-fontify-todo-headline t)
  (org-fontify-whole-heading-line t)
  (org-fontify-quote-and-verse-blocks t)
  (org-hide-emphasis-markers t)
  (org-fontify-emphasized-text t))

(provide 'org-config)
