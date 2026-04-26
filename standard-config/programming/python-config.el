(use-package python
  :ensure t

  :after (smartparens
          rainbow-delimiters
          sphinx-doc
          flycheck-eglot
          projectile
          virtualenvwrapper)

  :config
  ;; Set ipython as the python interpreter
  (setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "--colors NoColor --simple-prompt"
        python-shell-prompt-regexp "In \\[[0-9]+\\]: "
        python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
        python-shell-completion-native-enable nil
        python-shell-completion-setup-code "from IPython.core.completerlib import module_completion"
        python-shell-completion-string-code "';'.join(module_completion('''%s'''))\n"
        python-shell-completion-string-code "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

  (add-to-list 'eglot-server-programs
               `(python-mode . ("uvx" "ty" "server")))

  :hook
  (python-mode . electric-pair-mode)
  (python-mode . smartparens-mode)
  (python-mode . smartparens-mode)
  (python-mode . rainbow-delimiters-mode)
  (python-mode . sphinx-doc-mode)
  (python-mode . flycheck-mode)
  (python-mode . (lambda ()
                   ;; The LSP backend for python
                   ;; `jedi-language-server` doesn't provide flycheck
                   ;; capabilities. So we configure flycheck-eglot to
                   ;; consider other syntax checkers too
                   (setq flycheck-eglot-exclusive nil)
                   (eglot-ensure))))

(provide 'python-config)
