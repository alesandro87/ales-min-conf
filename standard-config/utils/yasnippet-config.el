;;; yasnippet-config.el -*- lexical-binding: t; -*-
(use-package yasnippet
  ;; yasnippet
  :ensure t
  ;; markdown-mode deriva da text-mode, quindi è già coperto
  :hook ((text-mode
          prog-mode
          conf-mode
          snippet-mode) . yas-minor-mode-on)
  ;; :init
  )

(use-package yasnippet-snippets
  :ensure t
  :config
  ;; Gli snippet del pacchetto si registrano già da soli (autoload di
  ;; yasnippet-snippets-initialize).  yas-reload-all carica anche quelli
  ;; personali di yas-snippet-dirs (~/.emacs.d/snippets) e toglie i
  ;; caricamenti duplicati.
  (yas-reload-all))

(provide 'yasnippet-config)
