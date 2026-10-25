;;; embark-config.el -*- lexical-binding: t; -*-
;; Azioni sul candidato del minibuffer o sull'oggetto sotto il cursore.
;; C-. non arriva da molti terminali: lì M-x embark-act.
(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-h B" . embark-bindings)))

;; Integrazione con consult (export, anteprima): la carica embark stesso
;; quando c'è consult, qui basta installarla.
(use-package embark-consult
  :ensure t
  :defer t)

;; flyspell lega C-. a `flyspell-auto-correct-word', che resta su C-M-i:
;; lo si toglie perché nei buffer Org C-. arrivi a embark.
(with-eval-after-load 'flyspell
  (keymap-unset flyspell-mode-map "C-." t))

(provide 'embark-config)
