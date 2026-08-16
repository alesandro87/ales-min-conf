(use-package python
  :ensure t
  :mode ("\\.py\\'" . python-ts-mode)
  :config
  (setq python-shell-interpreter "ipython3"
        python-shell-interpreter-args "--colors NoColor --simple-prompt"
        python-shell-prompt-regexp "In \\[[0-9]+\\]: "
        python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
        python-shell-completion-native-enable nil
        python-shell-completion-setup-code "from IPython.core.completerlib import module_completion"
        python-shell-completion-string-code "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")

  (defun ap/python-ts-setup ()
    "Setup eglot + flycheck for python-ts-mode."
    (setq flycheck-eglot-exclusive nil)
    (eglot-ensure))

  (add-hook 'python-ts-mode-hook #'ap/python-ts-setup)
  :hook
  (python-ts-mode . electric-pair-mode)
  ;; (python-ts-mode . smartparens-mode)
  ;;(python-ts-mode . rainbow-delimiters-mode)
  (python-ts-mode . flycheck-mode))

(provide 'python-config)
