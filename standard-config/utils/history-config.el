;;; history-config.el --- Cronologia, file recenti, posizione -*- lexical-binding: t; -*-
;; minimal-emacs.d imposta le opzioni ma non attiva i mode.
;; savehist: cronologia del minibuffer (vertico); recentf: file recenti
;; in `consult-buffer'; save-place: riapre i file dove li si era lasciati.
(add-hook 'after-init-hook #'savehist-mode)
(add-hook 'after-init-hook #'recentf-mode)
(add-hook 'after-init-hook #'save-place-mode)

;; Il daemon salva i file recenti solo all'uscita: un salvataggio periodico
;; evita di perderli se Emacs termina male.
(declare-function recentf-save-list "recentf" ())

(defun my/recentf-save-quietly ()
  "Salva la lista dei file recenti senza messaggi nell'area eco."
  (when (bound-and-true-p recentf-mode)
    (let ((inhibit-message t))
      (recentf-save-list))))

(run-with-idle-timer 300 t #'my/recentf-save-quietly)

(provide 'history-config)
