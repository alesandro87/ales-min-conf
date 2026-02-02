;; Aggiungi clang-format
(use-package clang-format
  :ensure t
  :config
  (setq clang-format-style-option "file")
  
  ;; Remap TAB per usare clang-format invece dell'indentazione Emacs
  (defun my-clang-format-or-indent ()
    "Usa clang-format sulla regione se attiva, altrimenti indenta normalmente"
    (interactive)
    (if (use-region-p)
        (clang-format-region (region-beginning) (region-end))
      (indent-for-tab-command)))
  
  ;; Applica il binding a C e C++
  (add-hook 'c-mode-hook
            (lambda ()
              (local-set-key (kbd "C-i") 'my-clang-format-or-indent)
              (local-set-key (kbd "TAB") 'my-clang-format-or-indent)))
  (add-hook 'c++-ts-mode-hook
            (lambda ()
              (local-set-key (kbd "C-i") 'my-clang-format-or-indent)
              (local-set-key (kbd "TAB") 'my-clang-format-or-indent))))

(provide 'clang-format-config)
