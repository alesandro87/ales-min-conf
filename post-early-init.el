;;; post-early-init.el --- Override dei default di early-init.el -*- lexical-binding: t; no-byte-compile: t; -*-

;; Caricato da minimal-emacs.d alla fine di early-init.el, prima di init.el.
;; Posto per: package-archive-priorities, package-pinned-packages,
;; minimal-emacs-gc-cons-threshold e altri override dei default.

;; Niente melpa-stable: nessun pacchetto installato viene da lì (quelli
;; che ci sono stanno anche su GNU, NonGNU o MELPA, a priorità più alta),
;; e leggerne l'indice (~1,4 MB) costa ~50 ms a ogni avvio.
;; Si lavora su una copia: `assoc-delete-all' modifica la lista, che qui
;; è la costante di early-init.el.
(setq package-archives
      (assoc-delete-all "melpa-stable" (copy-sequence package-archives)))
