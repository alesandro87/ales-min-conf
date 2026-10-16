;; Senza hunspell flyspell-mode dà errore all'apertura di ogni file Org:
;; in quel caso il controllo ortografico resta spento.
(if (executable-find "hunspell")
    (progn
      (setq ispell-program-name "hunspell")
      (setq ispell-dictionary "it_IT")
      (add-hook 'org-mode-hook #'flyspell-mode))
  (message "flyspell-config: hunspell non trovato, controllo ortografico disattivato"))

(provide 'flyspell-config)
