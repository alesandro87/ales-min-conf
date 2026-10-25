;;; clang-format-config.el -*- lexical-binding: t; -*-
(defvar clang-format-executable)        ; clang-format
;; Aggiungi clang-format
(use-package clang-format
  :ensure t
  :config
  (setq clang-format-style-option "file")

  (defun my/clang-format-keys ()
    "Tasti di clang-format, solo se l'eseguibile c'è."
    (when (executable-find clang-format-executable)
      ;; (local-set-key (kbd "TAB")   #'clang-format-region)
      (local-set-key (kbd "C-c c b") #'clang-format-buffer)
      (local-set-key (kbd "C-c c r") #'clang-format-region)))

  (add-hook 'c-mode-hook      #'my/clang-format-keys)
  (add-hook 'c-ts-mode-hook   #'my/clang-format-keys)
  (add-hook 'c++-ts-mode-hook #'my/clang-format-keys)
  (add-hook 'c++-mode-hook    #'my/clang-format-keys))

(provide 'clang-format-config)
