;;; org-config.el -*- lexical-binding: t; -*-
;; Usata nell'hook di org-mode; cape viene caricato tramite autoload.
(declare-function cape-dict "cape" (&optional interactive))
(defvar cape-dict-file)

(use-package gnuplot
  :ensure t
  :defer t)

(use-package org
  :ensure t
  :defer t
  :commands (org-mode org-version)
  :mode
  ("\\.org\\'" . org-mode)

  :bind
  (("M-o" . org-search-view)        ; ← globale (nessun :map sopra)
   :map org-mode-map
   ("M-g i" . consult-org-heading)) ; ← resta solo in Org

  :hook
  ;; Aggiunge il dizionario in coda alle capf di Org, senza sostituirle:
  ;; restano pcomplete (#+keyword, tag, proprietà) e le capf globali di
  ;; cape (dabbrev, file, elisp-block) tramite `t'.
  ;; cape-dict usa grep e un file dizionario (/usr/share/dict/words):
  ;; su Windows di solito mancano, e senza resta spento.
  (org-mode . (lambda ()
                (when (and (executable-find "grep")
                           (require 'cape nil t)
                           (let ((files (ensure-list cape-dict-file)))
                             (and files
                                  (seq-every-p (lambda (f)
                                                 (and (stringp f) (file-readable-p f)))
                                               files))))
                  (add-hook 'completion-at-point-functions #'cape-dict 90 t))))

  :config
  ;; Carica moduli per i grafici Org
  (require 'gnuplot)
  (require 'org-plot)

  ;; Abilita i linguaggi in Org Babel aggiungendoli a quelli già attivi:
  ;; altri moduli (es. plantuml-config.el) ne aggiungono altri, e così il
  ;; risultato non dipende dall'ordine dei require.
  (dolist (lang '(gnuplot emacs-lisp lisp shell))
    (setf (alist-get lang org-babel-load-languages) t))
  (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)

  ;; Percorso dei file org-agenda per piattaforma
  (cond
   ((eq system-type 'windows-nt)
    (when (file-directory-p "C:\\Users\\atanasio\\Work\\Note")
      (setq org-agenda-files (directory-files-recursively "C:\\Users\\atanasio\\Work\\Note" "\\.org$"))))
   ((eq system-type 'gnu/linux)
    ;;(setq org-agenda-files (directory-files-recursively "~/Work/Note/Elen/Sprint/" "\\.org$"))
    (when (file-directory-p "~/Note/")
      (setq org-agenda-files (directory-files-recursively "~/Note/" "\\.org$")))))

  (setq org-todo-keywords
        '((sequence "TODO(t)" "IN_PROGRESS(p)" "DONE(d)" "WAITING(w)")))
  
  (setq org-todo-keyword-faces
        '(("TODO" . (:foreground "hot pink" :weight bold))
          ("IN_PROGRESS" . (:foreground "yellow" :weight bold))
          ("WAITING" . (:foreground "orange" :weight bold))
          ;; ("REVIEW" . (:foreground "cyan" :weight bold))
          ("DONE" . (:foreground "green" :weight bold))
          ;; ("CANCELLED" . (:foreground "red" :weight bold)
          ))
  
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
  (org-fontify-emphasized-text t)
  (org-babel-lisp-eval-fn #'sly-eval))

(provide 'org-config)
