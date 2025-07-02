;;; common.el --- Configurazioni comuni a tutti gli OS -*- lexical-binding: t; -*-

(my/load-config "single/ales-config.el")

;; loading i buffer
(my/load-config "single/ibuffer-config.el")

;; loading magit
(my/load-config "single/magit-config.el")

;; loading python
(my/load-config "single/python-config.el")
 
;; loading go
;(my/load-config "single/go-config.el")


(use-package emojify
  :ensure t
  :config
  (setq emojify-display-style 'unicode)
  (setq emojify-emoji-styles '(unicode))
  :hook (after-init . global-emojify-mode))

;; sbcl configuration for common lisp programming
(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "sbcl")
  (setq slime-contribs '(slime-fancy))
  (slime-setup '(slime-fancy slime-quicklisp slime-asdf))
  :bind ("C-c s" . slime))

;; display time in the modeline
(add-hook 'after-init-hook #'display-time-mode)

;; theme
(mapc #'disable-theme custom-enabled-themes)  ; Disable all active themes
                                        ;(load-theme 'tango-dark t)  ; Load the built-in theme
                                        ;(load-theme 'modus-operandi t)  ; Load the built-in theme
(load-theme 'adwaita t)

(use-package vertico
  ;; (Note: It is recommended to also enable the savehist package.)
  :ensure t
  :defer t
  :commands vertico-mode
  :hook (after-init . vertico-mode))

(use-package orderless
  ;; Vertico leverages Orderless' flexible matching capabilities, allowing users
  ;; to input multiple patterns separated by spaces, which Orderless then
  ;; matches in any order against the candidates.
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  ;; Marginalia allows Embark to offer you preconfigured actions in more contexts.
  ;; In addition to that, Marginalia also enhances Vertico by adding rich
  ;; annotations to the completion candidates displayed in Vertico's interface.
  :ensure t
  :defer t
  :commands (marginalia-mode marginalia-cycle)
  :hook (after-init . marginalia-mode))

;; Corfu - Autocompletamento moderno
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)                 ; Completamento automatico
  (corfu-auto-delay 0.5)         ; Ritardo 0.5 secondi
  (corfu-auto-prefix 2)          ; Min 2 caratteri
  :bind
  (:map corfu-map
        ("TAB" . corfu-insert)     ; TAB per completare
        ([tab] . corfu-insert)     ; TAB alternativo
        ("RET" . nil)              ; Disabilita completamento con Invio
        ("<return>" . nil))
  
        ;("TAB" . corfu-next)
        ;("S-TAB" . corfu-previous)
  ;("TAB" . corfu-insert))

  :hook (
         (prog-mode . corfu-mode)
         (markdown-mode . (lambda ()
                            (setq-local completion-at-point-functions
                                        (list #'cape-dabbrev     ; Parole già scritte
                                              #'cape-file        ; Percorsi file
                                              #'cape-dict        ; Dizionario parole
                                              ;; #'cape-emoji
                                              ))))   

         (org-mode . (lambda ()
                       (setq-local completion-at-point-functions
                                   (list #'cape-dabbrev     ; Parole già scritte
                                         #'cape-file        ; Percorsi file
                                         #'cape-dict        ; Dizionario parole
                                         ;; #'cape-emoji
                                         ))))
         )
  )

;; Supporto per terminale - usa corfu-terminal
;; (use-package corfu-terminal
;;   :ensure t
;;   :after corfu
;;   :config
;;   ;; Abilita corfu-terminal solo quando si usa Emacs in terminale
;;   (unless (display-graphic-p)
;;     (corfu-terminal-mode +1)))


;; Cape - Estensioni completamento
(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  )

;; Orderless - Matching flessibile
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic)))

(use-package yasnippet
  ;; yasnippet
  :ensure t
  :hook ((text-mode
          prog-mode
          conf-mode
          markdown-mode-hook
          snippet-mode) . yas-minor-mode-on)
  ;; :init
  )

(use-package yasnippet-snippets
  ;; load all snippet
  :ensure t
  )

(use-package markdown-mode
  ;; markdown mode  
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode))
  :init (setq markdown-command "pandoc")
  )

(use-package markdown-preview-mode
  :ensure t
  ;; :hook (markdown-mode . markdown-preview-mode)
  )

(use-package org
  :ensure t
  :defer t
  :commands (org-mode org-version)
  :mode
  ("\\.org\\'" . org-mode)

  :bind
  (("M-o" . org-search-view))

  :config
    ;; load the correct path
  ;; (setq org-agenda-files (directory-files-recursively "C:\\Users\\atanasio\\Work\\Note" "\\.org$"))
  (cond
   ((eq system-type 'windows-nt)
    (setq org-agenda-files (directory-files-recursively "C:\\Users\\atanasio\\Work\\Note" "\\.org$")))
   ((eq system-type 'gnu/linux)
    (setq org-agenda-files (directory-files-recursively "~/Work/Note/" "\\.org$")))
   ((eq system-type 'darwin)  ; macOS
    (setq org-agenda-files (directory-files-recursively "~/Work/Note/" "\\.org$"))))
  
  ;; La tua funzione per pulire le righe vuote
  (defun clear-double-return ()
    "Rimuove righe vuote multiple lasciandone solo una"
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "\n\n+" nil t)
        (replace-match "\n\n"))))

  ;; Configurazione font per emoji
  (set-fontset-font t 'symbol 
                    (cond
                     ((eq system-type 'windows-nt) "Segoe UI Emoji")
                     ((eq system-type 'darwin) "Apple Color Emoji")
                     ((eq system-type 'gnu/linux) "Noto Color Emoji"))
                    nil 'prepend)
  
  :hook(
        ((org-mode . (lambda ()
                       (setq-local prettify-symbols-alist
                                   '(("lambda" . ?λ)
                                     ("->" . ?→)
                                     ("map" . ?↦)
                                     ("/=" . ?≠)
                                     ("!=" . ?≠)
                                     ("==" . ?≡)
                                     ("<=" . ?≤)
                                     (">=" . ?≥)
                                     ("&&" . ?∧)
                                     ("||" . ?∨)
                                     ("sqrt" . ?√)
                                     ("..." . ?…)))
                       (prettify-symbols-mode 1)
                       (visual-line-mode 1)
                       (face-remap-add-relative 'bold :foreground "magenta")))))

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

(use-package dired-sidebar
  :ensure t
  :bind (("M-0" . dired-sidebar-toggle-sidebar))
  :config
  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t)
  (setq dired-sidebar-width 30 )
  (setq dired-sidebar-use-term-integration t))

