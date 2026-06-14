(use-package sly
  :ensure t
  :config
  ;; (setq inferior-lisp-program "/usr/bin/sbcl")
  (setq inferior-lisp-program "/usr/bin/ecl")
  (add-hook 'lisp-mode-hook 'sly-editing-mode))

;;; -------------------------------------------------------------------
;;; imenu dettagliato per Common Lisp (granularità in stile clangd)
;;;
;;; Non esiste un language server per CL nel setup (sly+ecl), quindi
;;; `lisp-mode' usa l'imenu a regex di Emacs: solo defun/defvar di primo
;;; livello, senza "kind", senza parametri, senza annidamento.
;;;
;;; Qui si costruisce un `imenu-create-index-function' che, come la
;;; versione eglot in imenu-list-config.el, produce etichette del tipo
;;;   ƒ NOME  (LAMBDA-LIST)
;;; con prefisso del tipo di simbolo e, per defclass/defstruct/
;;; define-condition, gli slot come voci figlie.
;;; -------------------------------------------------------------------

;; Facce condivise (my/imenu-kind-face, my/imenu-params-face) e la
;; larghezza my/imenu-detail-max-width sono definite in
;; imenu-list-config.el, caricato da utils-config prima di questo file.

(defconst my/cl-imenu-definers
  '(;; funzioni / macro (mostrano la lambda-list)
    ("defun"                  "ƒ" func)   ("defmacro"            "µ" func)
    ("defgeneric"             "G" func)   ("defmethod"           "m" method)
    ("define-compiler-macro"  "µ" func)   ("define-modify-macro" "µ" func)
    ("defsetf"                "ƒ" func)   ("define-setf-expander" "ƒ" func)
    ;; classi / tipi -> C  (slot come figli)
    ("defclass"               "C" class)  ("define-condition"    "C" class)
    ("defstruct"              "C" struct) ("deftype"             "T" func)
    ;; variabili -> ○
    ("defvar"                 "○" var)    ("defparameter"        "○" var)
    ("defconstant"            "○" var)    ("define-symbol-macro" "○" var)
    ;; pacchetti -> P
    ("defpackage"             "P" pkg)    ("in-package"          "P" pkg))
  "Operatori CL riconosciuti: (NOME PREFISSO TIPO).")

(defun my/cl-imenu--skip-ws ()
  "Salta spazi e commenti dal punto corrente."
  (forward-comment (point-max)))

(defun my/cl-imenu--next ()
  "Legge il prossimo sexp nella lista corrente.
Ritorna (KIND . STRINGA), KIND fra `list' e `atom', oppure nil
a fine lista/buffer. Muove il punto oltre il sexp."
  (my/cl-imenu--skip-ws)
  (unless (or (eobp) (eq (char-after) ?\)))
    (let ((listp (eq (char-after) ?\())
          (start (point)))
      (condition-case nil
          (progn (forward-sexp)
                 (cons (if listp 'list 'atom)
                       (buffer-substring-no-properties start (point))))
        (scan-error nil)))))

(defun my/cl-imenu--inner-name (s)
  "Se S è \"(nome ...)\" ritorna nome, altrimenti S ripulito."
  (let ((s (string-trim s)))
    (if (string-prefix-p "(" s)
        (if (string-match "[^ \t\n\r()]+" s 1) (match-string 0 s) s)
      s)))

(defun my/cl-imenu--truncate (s)
  (if (> (length s) my/imenu-detail-max-width)
      (concat (substring s 0 (1- my/imenu-detail-max-width)) "…")
    s))

(defun my/cl-imenu--label (prefix name params)
  "Compone l'etichetta colorata: [PREFIX] NAME  (PARAMS)."
  (let ((head (concat (propertize prefix 'face 'my/imenu-kind-face) " " name)))
    (if (and params (> (length params) 0))
        (concat head "  " (propertize (my/cl-imenu--truncate params)
                                      'face 'my/imenu-params-face))
      head)))

(defun my/cl-imenu--with-children (label pos children)
  "Voce con figli (slot). Aggiunge una voce \"→\" che salta al form."
  (if children
      (cons label
            (cons (cons (concat "→ " label) pos)
                  (mapcar (lambda (c)
                            (cons (concat (propertize "·" 'face 'my/imenu-kind-face)
                                          " " (car c))
                                  (cdr c)))
                          children)))
    (cons label pos)))

(defun my/cl-imenu--lambda-list (methodp form-end)
  "Dal punto (dopo il nome) trova la lambda-list = primo sexp lista.
Per i metodi antepone gli eventuali qualificatori (es. :before)."
  (let ((quals '()) (params nil))
    (catch 'done
      (while (< (point) form-end)
        (my/cl-imenu--skip-ws)
        (when (or (>= (point) form-end) (eq (char-after) ?\)))
          (throw 'done nil))
        (let ((listp (eq (char-after) ?\())
              (tok (my/cl-imenu--next)))
          (unless tok (throw 'done nil))
          (if listp
              (progn (setq params (cdr tok)) (throw 'done nil))
            (when methodp (push (cdr tok) quals))))))
    (let ((q (when quals (mapconcat #'identity (nreverse quals) " "))))
      (cond ((and q params) (concat q " " params))
            (params params)
            (t nil)))))

(defun my/cl-imenu--slot-list ()
  "Punto sul `(' di una lista di slot. Ritorna ((NOME . POS) ...)."
  (let ((res '()))
    (when (eq (char-after) ?\()
      (let ((end (save-excursion (forward-sexp) (point))))
        (forward-char 1)
        (my/cl-imenu--skip-ws)
        (while (and (< (point) end) (not (eq (char-after) ?\))))
          (let ((pos (point)) (tok (my/cl-imenu--next)))
            (when tok
              (push (cons (my/cl-imenu--inner-name (cdr tok)) pos) res)))
          (my/cl-imenu--skip-ws))
        (goto-char end)))
    (nreverse res)))

(defun my/cl-imenu--class-slots (form-end)
  "Per defclass/define-condition: salta le superclassi, legge gli slot."
  (my/cl-imenu--skip-ws)
  (when (and (< (point) form-end) (eq (char-after) ?\())   ; superclassi
    (forward-sexp))
  (my/cl-imenu--skip-ws)
  (when (and (< (point) form-end) (eq (char-after) ?\())
    (my/cl-imenu--slot-list)))

(defun my/cl-imenu--struct-slots (form-end)
  "Per defstruct: gli slot sono i sexp restanti del form."
  (let ((res '()))
    (my/cl-imenu--skip-ws)
    (when (and (< (point) form-end) (eq (char-after) ?\")) ; docstring opzionale
      (my/cl-imenu--next) (my/cl-imenu--skip-ws))
    (while (and (< (point) form-end) (not (eq (char-after) ?\)))
                (not (eobp)))
      (let ((pos (point)) (tok (my/cl-imenu--next)))
        (if tok
            (progn (push (cons (my/cl-imenu--inner-name (cdr tok)) pos) res)
                   (my/cl-imenu--skip-ws))
          (goto-char form-end))))
    (nreverse res)))

(defun my/cl-imenu--parse-form (form-end)
  "Punto sul `(' di un form di primo livello. Ritorna la voce imenu o nil."
  (let ((form-start (point)))
    (forward-char 1)
    (let ((op (my/cl-imenu--next)))
      (when (and op (eq (car op) 'atom))
        (let ((spec (assoc (downcase (cdr op)) my/cl-imenu-definers)))
          (when spec
            (let* ((prefix (nth 1 spec))
                   (kind   (nth 2 spec))
                   (nametok (my/cl-imenu--next))
                   (rawname (and nametok (cdr nametok))))
              (when rawname
                (let ((name (my/cl-imenu--inner-name rawname)))
                  (pcase kind
                    ((or 'func 'method)
                     (cons (my/cl-imenu--label
                            prefix name
                            (my/cl-imenu--lambda-list (eq kind 'method) form-end))
                           form-start))
                    ('pkg
                     (cons (my/cl-imenu--label prefix rawname nil) form-start))
                    ('class
                     (my/cl-imenu--with-children
                      (my/cl-imenu--label prefix name nil) form-start
                      (my/cl-imenu--class-slots form-end)))
                    ('struct
                     (my/cl-imenu--with-children
                      (my/cl-imenu--label prefix name nil) form-start
                      (my/cl-imenu--struct-slots form-end)))
                    (_  ; var e altri
                     (cons (my/cl-imenu--label prefix name nil) form-start))))))))))))

(defun my/cl-imenu-create-index ()
  "`imenu-create-index-function' dettagliato per Common Lisp."
  (let ((index '()))
    (save-excursion
      (goto-char (point-min))
      (my/cl-imenu--skip-ws)
      (while (< (point) (point-max))
        (if (eq (char-after) ?\()
            (let ((form-end (save-excursion
                              (condition-case nil (progn (forward-sexp) (point))
                                (scan-error (point-max))))))
              (save-excursion
                (let ((entry (my/cl-imenu--parse-form form-end)))
                  (when entry (push entry index))))
              (goto-char form-end))
          (condition-case nil (forward-sexp) (scan-error (goto-char (point-max)))))
        (my/cl-imenu--skip-ws)))
    (nreverse index)))

(defun my/cl-use-detailed-imenu ()
  "Attiva l'imenu dettagliato nei buffer Common Lisp."
  (setq-local imenu-create-index-function #'my/cl-imenu-create-index))

;; `append' così gira dopo sly-editing-mode.
(add-hook 'lisp-mode-hook #'my/cl-use-detailed-imenu t)

(provide 'lisp-config)
