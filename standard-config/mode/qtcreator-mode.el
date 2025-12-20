;;; qtcreator-mode.el --- Qt Creator-like functionality for Emacs

;;; Commentary:
;; This mode adds Qt-specific functionality to c++-mode,
;; similar to those offered by Qt Creator.

;;; Code:

(require 'qtcreator-mode-logic)

;; Definition of major mode derived from c++-mode
(define-derived-mode qtcreator-mode c++-mode "Qt Creator"
  "Major mode for Qt development with advanced functionality.
Based on c++-mode with Qt-specific additions."
  
  ;; Qt-specific configurations
  (setq-local comment-start "// ")
  (setq-local comment-end "")
  
  ;; Add Qt keywords
  (font-lock-add-keywords nil
    '(("\\<\\(Q_OBJECT\\|Q_PROPERTY\\|Q_ENUMS\\|Q_FLAGS\\|Q_INTERFACES\\|Q_CLASSINFO\\|Q_PLUGIN_METADATA\\|Q_GADGET\\|Q_NAMESPACE\\)\\>" . font-lock-preprocessor-face)
      ("\\<\\(signals\\|slots\\|emit\\|foreach\\|forever\\|Q_FOREACH\\|Q_FOREVER\\)\\>" . font-lock-keyword-face)
      ("\\<\\(Q[A-Z][a-zA-Z0-9]*\\)\\>" . font-lock-type-face)))
  
  ;; Keyboard bindings configuration
  (define-key qtcreator-mode-map (kbd "C-c q h") 'qtcreator-say-hello)
  (define-key qtcreator-mode-map (kbd "C-c q p") 'qtcreator-generate-q-property)
  (define-key qtcreator-mode-map (kbd "C-c q s") 'qtcreator-generate-getter-setter)
  (define-key qtcreator-mode-map (kbd "C-c q o") 'qtcreator-insert-q-object)
  (define-key qtcreator-mode-map (kbd "C-c q ?") 'qtcreator-mode-status)
  (define-key qtcreator-mode-map (kbd "C-c q t") 'qtcreator-mode-toggle))

;; simple function to hello 
(defun qtcreator-say-hello()
  (interactive)
  (hello-qtcreator-mode))

;; Keymap for qtcreator-mode
(defvar qtcreator-mode-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map c++-mode-map)
    map)
  "Keymap for qtcreator-mode.")

;; Main function to generate Q_PROPERTY
(defun qtcreator-generate-q-property ()
  "Automatically generate a Q_PROPERTY macro based on the variable under cursor."
  (interactive)
  (save-excursion
    (let* ((member-info (qtcreator-parse-member-variable))
           (type (car member-info))
           (var-name (cadr member-info))
           (property-name (caddr member-info)))
      
      (if (and type var-name property-name)
          (progn
            ;; Find where to insert Q_PROPERTY (after Q_OBJECT or class beginning)
            (let ((insert-point (qtcreator-find-property-insertion-point)))
              (if insert-point
                  (progn
                    (goto-char insert-point)
                    (qtcreator-insert-q-property type property-name)
                    (message "Q_PROPERTY generated for %s" property-name))
                (message "Cannot find insertion point for Q_PROPERTY"))))
        (message "Member variable not recognized. Position cursor on a line like 'QString m_name;'")))))


;; Function to insert Q_PROPERTY
(defun qtcreator-insert-q-property (type property-name)
  "Insert a Q_PROPERTY with the specified type and name."
  (let ((getter-name property-name)
        (setter-name (concat "set" (capitalize property-name)))
        (signal-name (concat property-name "Changed")))
    
    ;; Insert Q_PROPERTY with appropriate indentation
    (insert (format "    Q_PROPERTY(%s %s READ %s WRITE %s NOTIFY %s)\n"
                    type property-name getter-name setter-name signal-name))))

;; Function to generate getter and setter
(defun qtcreator-generate-getter-setter ()
  "Generate getter, setter and signal for the variable under cursor."
  (interactive)
  (save-excursion
    (let* ((member-info (qtcreator-parse-member-variable))
           (type (car member-info))
           (var-name (cadr member-info))
           (property-name (caddr member-info)))
      
      (if (and type var-name property-name)
          (progn
            ;; Find public section for methods
            (let ((public-point (qtcreator-find-public-section)))
              (if public-point
                  (progn
                    (goto-char public-point)
                    (qtcreator-insert-getter-setter type var-name property-name)
                    (message "Getter, setter and signal generated for %s" property-name))
                (message "Cannot find public section"))))
        (message "Member variable not recognized")))))

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

;; Function to insert Q_OBJECT
(defun qtcreator-insert-q-object ()
  "Insert Q_OBJECT in the current class."
  (interactive)
  (save-excursion
    (if (re-search-backward "class\\s-+\\([A-Za-z_][A-Za-z0-9_]*\\)" nil t)
        (progn
          (if (re-search-forward "{" nil t)
              (progn
                (forward-line 1)
                (insert "    Q_OBJECT\n\n")
                (message "Q_OBJECT inserted"))
            (message "Cannot find class opening brace")))
      (message "Cannot find class declaration"))))

;; Function to check if qtcreator-mode is active
(defun qtcreator-mode-status ()
  "Show qtcreator-mode status in the current buffer."
  (interactive)
  (if (eq major-mode 'qtcreator-mode)
      (message "QtCreator mode is ACTIVE in current buffer (%s)" (buffer-name))
    (message "QtCreator mode is NOT active in current buffer (%s). Current mode: %s" 
             (buffer-name) major-mode)))

;; Function to enable/disable qtcreator-mode
(defun qtcreator-mode-toggle ()
  "Enable or disable qtcreator-mode in the current buffer."
  (interactive)
  (if (eq major-mode 'qtcreator-mode)
      (progn
        (c++-mode)
        (message "QtCreator mode disabled - switched back to c++-mode"))
    (if (or (eq major-mode 'c++-mode) (eq major-mode 'c-mode))
        (progn
          (qtcreator-mode)
          (message "QtCreator mode enabled"))
      (message "Cannot enable QtCreator mode - buffer is not in C/C++ mode"))))

;; Hooks for Qt files
;; (add-to-list 'auto-mode-alist '("\\.h\\'" . qtcreator-mode))
;; (add-to-list 'auto-mode-alist '("\\.hpp\\'" . qtcreator-mode))
;; (add-to-list 'auto-mode-alist '("\\.cpp\\'" . qtcreator-mode))
;; (add-to-list 'auto-mode-alist '("\\.cc\\'" . qtcreator-mode))
;; (add-to-list 'auto-mode-alist '("\\.cxx\\'" . qtcreator-mode))

(provide 'qtcreator-mode)

;;; qtcreator-mode.el ends here
