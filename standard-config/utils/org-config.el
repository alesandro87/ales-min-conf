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

  ;; Abilita i linguaggi in Org Babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((gnuplot . t)
     (emacs-lisp . t)
     (lisp . t)
     (shell . t)))
  (setq org-babel-lisp-eval-fn #'sly-eval) ; ← aggiunto, se usi Sly

  ;; Percorso dei file org-agenda per piattaforma
  (cond
   ((eq system-type 'windows-nt)
    (when (file-directory-p "C:\\Users\\atanasio\\Work\\Note")
      (setq org-agenda-files (directory-files-recursively "C:\\Users\\atanasio\\Work\\Note" "\\.org$"))))
   ((eq system-type 'gnu/linux)
    (when (file-directory-p "~/Note/")
      (setq org-agenda-files (directory-files-recursively "~/Note/" "\\.org$"))))
   ;;(setq org-agenda-files (directory-files-recursively "~/Work/Note/Elen/Sprint/" "\\.org$")))
   ((eq system-type 'darwin)  ; macOS
    (when (file-directory-p "~/Note/")
      (setq org-agenda-files (directory-files-recursively "~/Note/" "\\.org$")))))
  
  ;; La tua funzione per pulire le righe vuote
  (defun clear-double-return ()
    "Rimuove righe vuote multiple lasciandone solo una"
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "\n\n+" nil t)
        (replace-match "\n\n"))))

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
  
  ;; Configurazione font per emoji
  (when (fboundp 'set-fontset-font)
    (set-fontset-font t 'symbol
                      (cond
                       ((eq system-type 'windows-nt) "Segoe UI Emoji")
                       ((eq system-type 'darwin) "Apple Color Emoji")
                       ((eq system-type 'gnu/linux) "Noto Color Emoji"))
                      nil 'prepend))
  
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
