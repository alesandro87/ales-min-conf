;;; qtcreator-mode-logic.el --- Funzioni di esempio

(defun hello-qtcreator-mode()
  "print hello in the minibuffer"
  (message "hello qtcreator-mode"))

;; Function to parse a member variable
(defun qtcreator-parse-member-variable ()
  "Parse the member variable on the current line.
Returns a list (type variable-name property-name) or nil if not recognized."
  (save-excursion
    (beginning-of-line)
    (when (looking-at "\\s-*\\([A-Za-z_][A-Za-z0-9_:<>]*\\)\\s-+\\(m_\\([a-zA-Z_][a-zA-Z0-9_]*\\)\\)\\s-*;")
      (let ((type (match-string 1))
            (var-name (match-string 2))
            (property-name (match-string 3)))
        (list type var-name property-name)))))

;; Function to find Q_PROPERTY insertion point
(defun qtcreator-find-property-insertion-point ()
  "Find the point where to insert Q_PROPERTY in the current class."
  (save-excursion
    (let ((current-pos (point)))
      ;; Search for Q_OBJECT upwards
      (if (re-search-backward "Q_OBJECT" nil t)
          (progn
            (end-of-line)
            (forward-line 1)
            (point))
        ;; If Q_OBJECT not found, search for public section beginning
        (goto-char current-pos)
        (if (re-search-backward "^\\s-*\\(public\\|private\\|protected\\)\\s-*:" nil t)
            (progn
              (forward-line 1)
              (point))
          ;; As last resort, search for class opening brace
          (goto-char current-pos)
          (if (re-search-backward "{" nil t)
              (progn
                (forward-line 1)
                (point))
            nil))))))

;; Function to insert Q_PROPERTY
(defun qtcreator-insert-q-property (type property-name)
  "Insert a Q_PROPERTY with the specified type and name."
  (let ((getter-name property-name)
        (setter-name (concat "set" (capitalize property-name)))
        (signal-name (concat property-name "Changed")))
    
    ;; Insert Q_PROPERTY with appropriate indentation
    (insert (format "    Q_PROPERTY(%s %s READ %s WRITE %s NOTIFY %s)\n"
                    type property-name getter-name setter-name signal-name))))


;; Function to find public section
(defun qtcreator-find-public-section ()
  "Find the public section of the class."
  (save-excursion
    (if (re-search-backward "^\\s-*public\\s-*:" nil t)
        (progn
          (forward-line 1)
          (point))
      nil)))

;; Function to insert getter, setter and signal
(defun qtcreator-insert-getter-setter (type var-name property-name)
  "Insert getter, setter and signal for a property."
  (let ((getter-name property-name)
        (setter-name (concat "set" (capitalize property-name)))
        (signal-name (concat property-name "Changed"))
        (const-ref-type (if (qtcreator-is-simple-type type) type (concat "const " type "&"))))
    
    ;; Insert getter
    (insert (format "    %s %s() const { return %s; }\n" const-ref-type getter-name var-name))
    
    ;; Insert setter
    (insert (format "    void %s(%s value) {\n" setter-name const-ref-type))
    (insert (format "        if (%s != value) {\n" var-name))
    (insert (format "            %s = value;\n" var-name))
    (insert (format "            emit %s();\n" signal-name))
    (insert "        }\n")
    (insert "    }\n\n")
    
    ;; Find and insert signal in signals section
    (qtcreator-insert-signal signal-name)))

;; Function to determine if a type is simple
(defun qtcreator-is-simple-type (type)
  "Determine if a type is simple (doesn't need const reference)."
  (member type '("int" "float" "double" "bool" "char" "short" "long" "unsigned"
                 "qint8" "quint8" "qint16" "quint16" "qint32" "quint32" "qint64" "quint64"
                 "qreal")))

;; Function to insert signal
(defun qtcreator-insert-signal (signal-name)
  "Insert a signal in the appropriate signals section."
  (save-excursion
    (if (re-search-backward "^\\s-*signals\\s-*:" nil t)
        (progn
          (forward-line 1)
          (insert (format "    void %s();\n" signal-name)))
      ;; If signals section not found, create it
      (if (re-search-backward "^\\s-*\\(public\\|private\\|protected\\)\\s-*:" nil t)
          (progn
            (end-of-line)
            (insert "\n\nsignals:")
            (insert (format "\n    void %s();\n" signal-name)))))))


(provide 'qtcreator-mode-logic)
