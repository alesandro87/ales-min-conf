;; plantuml-mode chiede la sintassi all'eseguibile già all'apertura del file:
;; senza plantuml installato ogni .puml darebbe errore.  In quel caso mode e
;; integrazione Org restano spenti e i file si aprono come testo.
(defvar my/plantuml-executable (executable-find "plantuml")
  "Eseguibile di PlantUML, o nil se non è installato.")

;; Mai il mode 'server (il default del pacchetto): manderebbe i diagrammi a
;; plantuml.com.  Impostato prima che il pacchetto sia caricato, vale anche
;; se plantuml-mode viene caricato per altre vie (Org, M-x).
(setq plantuml-default-exec-mode 'executable)

(if (not my/plantuml-executable)
    (progn
      ;; Toglie le associazioni registrate dagli autoload del pacchetto
      (setq auto-mode-alist (rassq-delete-all 'plantuml-mode auto-mode-alist))
      ;; Nei blocchi src di Org (colori, C-c ') niente plantuml-mode
      (with-eval-after-load 'org-src
        (add-to-list 'org-src-lang-modes '("plantuml" . fundamental))))

  (use-package plantuml-mode
    :ensure t
    :mode ("\\.plantuml\\'" "\\.puml\\'")
    :config
    (setq plantuml-executable-path my/plantuml-executable
          plantuml-indent-level 2))

  ;; Integrazione con Org: si applica quando Org viene caricato
  (with-eval-after-load 'org
    (setq org-plantuml-exec-mode 'plantuml
          ;; ob-plantuml lo mette nel comando shell così com'è: va quotato
          ;; (es. "C:/Program Files/...")
          org-plantuml-executable-path (shell-quote-argument my/plantuml-executable))
    (add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
    (add-to-list 'org-babel-load-languages '(plantuml . t))
    (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)))

(provide 'plantuml-config)
