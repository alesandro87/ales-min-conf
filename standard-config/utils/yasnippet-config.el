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

;; :defer 1: si carica dopo 1 s di inattività, non all'avvio (~65 ms).
;; Non :after yasnippet: caricati dal primo buffer C/Python/..., gli
;; snippet di quel mode verrebbero letti subito tre volte (autoload, file
;; del pacchetto, yas-reload-all), ~200 ms all'apertura del file.
(use-package yasnippet-snippets
  :ensure t
  :defer 1
  :config
  ;; Gli snippet del pacchetto si registrano già da soli (autoload di
  ;; yasnippet-snippets-initialize).  yas-reload-all carica anche quelli
  ;; personali di yas-snippet-dirs (~/.emacs.d/snippets) e toglie i
  ;; caricamenti duplicati.
  (yas-reload-all))

(provide 'yasnippet-config)
