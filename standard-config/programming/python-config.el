;;; python-config.el -*- lexical-binding: t; -*-
(declare-function my/eglot-ensure-if-found "eglot-config" (&rest programs))
(use-package python
  :ensure t
  ;; .py apre python-mode; treesit-config.el lo rimappa a python-ts-mode
  ;; solo se c'è la grammatica
  :config
  (setq python-shell-interpreter "ipython3"
        python-shell-interpreter-args "--colors NoColor --simple-prompt"
        python-shell-prompt-regexp "In \\[[0-9]+\\]: "
        python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
        python-shell-completion-native-enable nil
        python-shell-completion-setup-code "from IPython.core.completerlib import module_completion"
        python-shell-completion-string-code "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

  (defun my/python-setup ()
    "Eglot in python-mode e python-ts-mode, se c'è un server.
I programmi sono quelli che eglot prova per Python (`eglot-server-programs')."
    (my/eglot-ensure-if-found "pylsp" "pyls" "basedpyright-langserver"
                              "pyright-langserver" "jedi-language-server"
                              "ruff" "ruff-lsp"))

  (add-hook 'python-mode-hook #'my/python-setup)
  (add-hook 'python-ts-mode-hook #'my/python-setup)
  :hook
  ((python-mode python-ts-mode) . electric-pair-local-mode))

(provide 'python-config)
