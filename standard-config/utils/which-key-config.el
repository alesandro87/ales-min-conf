;;; which-key-config.el -*- lexical-binding: t; -*-
;; Integrato in Emacs 30: dopo un prefisso mostra i tasti che seguono.
(use-package which-key
  :ensure nil
  :hook (after-init . which-key-mode)
  :config
  (which-key-add-key-based-replacements
    "C-c m" "build/esecuzione"
    "C-c v" "vterm"
    "C-c p" "progetto"
    "C-c c" "clang-format"
    "M-+"   "cape"))

(provide 'which-key-config)
