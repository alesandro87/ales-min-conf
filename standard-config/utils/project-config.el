;;; project-config.el --- Progetti con project.el (integrato) -*- lexical-binding: t; -*-

;;; Commentary:
;; La radice è il repository git.  Un sottomodulo fa parte del progetto
;; che lo include, con due limiti: un solo livello (in A → B → C, da C
;; si ottiene B) e solo con il `.git' come file, il formato attuale (i
;; vecchi sottomoduli con `.git' directory restano progetti separati).
;; La stessa radice la usano consult, eglot (un solo clangd per
;; superprogetto, entro questi limiti) e multi-vterm.
;;
;; `.project-root' segna una radice anche senza git: vale il marcatore
;; più vicino al file, quindi in una sottodirectory di un repository (o
;; di un sottomodulo) crea un progetto separato.
;;
;;   C-c p C-f  `consult-find'    - nomi di file nel progetto
;;   C-c p C-s  `consult-ripgrep' - testo nel progetto (serve `rg')
;;   (con C-u davanti si sceglie la directory di partenza)

;;; Code:

(declare-function consult-find "consult" (&optional dir initial))
(declare-function consult-ripgrep "consult" (&optional dir initial))

(use-package project
  :ensure nil
  :custom
  (project-vc-merge-submodules t)       ; il default, esplicito
  (project-vc-extra-root-markers '(".project-root")))

(global-set-key (kbd "C-c p C-f") #'consult-find)
(global-set-key (kbd "C-c p C-s") #'consult-ripgrep)

(provide 'project-config)

;;; project-config.el ends here
