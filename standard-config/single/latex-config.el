;; AUCTeX for LaTeX editing
(use-package auctex
  :ensure t
  :defer t
  :hook (LaTeX-mode . my-latex-mode-setup)
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-save-query nil
        TeX-PDF-mode t))

;; Function to configure LaTeX mode
(defun my-latex-mode-setup ()
  "Custom LaTeX editing settings."
  (visual-line-mode 1)
  (flyspell-mode 1)
  (LaTeX-math-mode 1)
  (turn-on-reftex)
  (setq reftex-plug-into-AUCTeX t)
  (setq TeX-source-correlate-mode t)
  (setq TeX-source-correlate-start-server t)
  (setq TeX-view-program-selection
        '((output-pdf "Evince") ;; Change to Okular or Zathura if preferred
          (output-dvi "xdvi")))
  (setq TeX-command-extra-options "-shell-escape") ;; Enable TikZ externalization, etc.
  )

;; PDF Tools for viewing with SyncTeX
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-page)
  (add-hook 'pdf-view-mode-hook 'pdf-view-midnight-minor-mode))

;; RefTeX for managing citations, labels, references
(use-package reftex
  :ensure t
  :defer t
  :hook (LaTeX-mode . reftex-mode))
