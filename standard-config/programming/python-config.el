;;; python-config.el -*- lexical-binding: t; -*-
(declare-function my/eglot-ensure-if-found "eglot-config" (&rest programs))
(use-package python
  :ensure t
  ;; .py apre python-mode; treesit-config.el lo rimappa a python-ts-mode
  ;; solo se c'è la grammatica
  :config
  (defun my/python-shell-setup ()
    "Shell Python: IPython se c'è sull'host del file, altrimenti python3/python.
python.el riconosce già prompt e completamento di IPython; la scelta è
per buffer (anche via TRAMP) e la shell la eredita da qui."
    (cond ((executable-find "ipython3" t)
           (setq-local python-shell-interpreter "ipython3"
                       python-shell-interpreter-args "--colors NoColor --simple-prompt"
                       python-shell-completion-native-enable nil))
          ((executable-find "python3" t)
           (setq-local python-shell-interpreter "python3"))
          ((executable-find "python" t)
           (setq-local python-shell-interpreter "python"))))

  (add-hook 'python-mode-hook #'my/python-shell-setup)
  (add-hook 'python-ts-mode-hook #'my/python-shell-setup)

  (defun my/python-setup ()
    "Eglot in python-mode e python-ts-mode, se c'è un server.
I programmi sono quelli che eglot prova per Python (`eglot-server-programs')."
    (my/eglot-ensure-if-found "pylsp" "pyls" "basedpyright-langserver"
                              "pyright-langserver" "jedi-language-server"
                              "ruff" "ruff-lsp"))

  (add-hook 'python-mode-hook #'my/python-setup)
  (add-hook 'python-ts-mode-hook #'my/python-setup))

(provide 'python-config)
