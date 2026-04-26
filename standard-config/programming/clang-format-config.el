;; Aggiungi clang-format
(use-package clang-format
  :ensure t
  :config
  (setq clang-format-style-option "file")

  (defun my-clang-format-or-indent ()
    "Indenta con clang-format se regione attiva, altrimenti TAB normale."
    (interactive)
    (if (use-region-p)
        (clang-format-region (region-beginning) (region-end))
      (indent-for-tab-command)))

  (defun my-c-mode-keybindings ()
    ;; (local-set-key (kbd "TAB")   #'clang-format-region)
    (local-set-key (kbd "C-c c b") #'clang-format-buffer)
    (local-set-key (kbd "C-c c r") #'clang-format-region))

  (add-hook 'c-mode-hook      #'my-c-mode-keybindings)
  (add-hook 'c++-ts-mode-hook #'my-c-mode-keybindings))

(provide 'clang-format-config)
