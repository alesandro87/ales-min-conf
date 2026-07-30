(setq ispell-program-name "hunspell")
(setq ispell-dictionary "it_IT")

(add-hook 'org-mode-hook #'flyspell-mode)

(provide 'flyspell-config)
