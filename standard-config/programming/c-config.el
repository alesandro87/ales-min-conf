;;; c-config.el -*- lexical-binding: t; -*-
(declare-function my/eglot-ensure-if-found "eglot-config" (&rest programs))
(use-package cc-mode
  :ensure t
  :defer t                              ; lo carica c-mode/c++-mode
  :config
  ;; Configurazione di base per C++
  (setq c-default-style "linux" c-basic-offset 4)

  ;; Configurazione specifica per Qt
  (c-set-offset 'innamespace 0)
  (c-set-offset 'access-label -2)
  (c-set-offset 'case-label 0))

(dolist (hook '(c-ts-mode-hook c++-ts-mode-hook c-mode-hook c++-mode-hook))
  (add-hook hook #'hs-minor-mode))
  
(defun my/c-ts-indent-setup ()
  "Indentazione tree-sitter: offset 4, stile k&r.
Lo stile va applicato con `c-ts-mode-set-style': le regole sono costruite
nel corpo del mode, prima degli hook, quindi un `setq-local' di
`c-ts-mode-indent-style' qui non avrebbe effetto.  L'offset va impostato
prima, perché alcune regole lo leggono quando vengono costruite.
Senza grammatica il mode salta il suo setup ma esegue gli hook: qui non
si fa nulla, perché ricostruire le regole darebbe errore."
  (when (treesit-ready-p (if (derived-mode-p 'c-ts-mode) 'c 'cpp) t)
    (setq-local c-ts-mode-indent-offset 4)
    (c-ts-mode-set-style 'k&r)))

(add-hook 'c-ts-mode-hook #'my/c-ts-indent-setup)
(add-hook 'c++-ts-mode-hook #'my/c-ts-indent-setup)

;;; - permette l'utilizzo di .dir-locals.el 
(defvar-local auto-format-on-save nil
  "Se non-nil (impostato via .dir-locals.el), formatta con eglot al salvataggio.")
(put 'auto-format-on-save 'safe-local-variable #'booleanp)

(declare-function eglot-managed-p "eglot" ())

(defun my/auto-format-on-save ()
  "Formatta con eglot prima di salvare, se `auto-format-on-save' è attivo."
  (when (and auto-format-on-save
             (fboundp 'eglot-managed-p)
             (eglot-managed-p))
    (eglot-format-buffer)))

(add-hook 'before-save-hook #'my/auto-format-on-save)
;;;

;; Configurazione per CMake
(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

;;; Comandi CMake: sorgenti nella radice del progetto (project.el) o in
;;; `my/cmake-source-dir'.
;;;
;;; - Con CMakePresets.json o CMakeUserPresets.json nei sorgenti si usano
;;;   i preset (`cmake --preset', `cmake --build --preset'): il preset fa
;;;   da kit (Qt, toolchain, directory di build).  La configure chiede
;;;   sempre il preset; build e clean riusano l'ultimo scelto, o quello
;;;   omonimo della configure (con C-u lo richiedono).  `my/cmake-preset'
;;;   è il preset proposto quando non ce n'è uno scelto prima.
;;; - Senza preset la build sta in `my/cmake-build-dir' e la configure
;;;   esporta compile_commands.json per clangd; con il generatore Visual
;;;   Studio (default su Windows) CMake lo ignora e clangd resta senza
;;;   database.  Con i preset lo esporta chi lo imposta nel preset.
;;; - Un SDK Yocto va nel preset (campi `environment' e `toolchainFile',
;;;   con l'ambiente del suo environment-setup-*), non in Emacs: così lo
;;;   stesso CMakePresets.json vale anche in Qt Creator e da terminale.
(declare-function project-root "project" (project))

(defvar my/cmake-source-dir nil
  "Directory dei sorgenti CMake, con il CMakeLists.txt principale.
Nil = radice del progetto.  Relativa alla radice del progetto o
assoluta; si imposta per progetto in .dir-locals.el.")

(defvar my/cmake-build-dir "build"
  "Directory di build senza preset, relativa ai sorgenti CMake.
\"build\" clangd la trova da solo; con un altro nome serve un .clangd nei
sorgenti con `CompilationDatabase: <nome>' sotto `CompileFlags:'.")

(defvar my/cmake-preset nil
  "Preset CMake proposto quando non ce n'è uno scelto prima, o nil.
Si imposta per progetto in .dir-locals.el.")
(put 'my/cmake-preset 'safe-local-variable #'stringp)

(defvar my/cmake--chosen-presets nil
  "Ultimi preset scelti: alist ((SORGENTI . TIPO) . NOME).")

(defun my/cmake--source-dir (ask)
  "Directory dei sorgenti CMake del buffer corrente.
Con ASK, o fuori da un progetto, la chiede."
  (let* ((project (project-current))
         (dir (and project
                   (expand-file-name (or my/cmake-source-dir "")
                                     (project-root project)))))
    (file-name-as-directory
     (expand-file-name
      (if (and dir (not ask))
          dir
        (read-directory-name "Sorgenti CMake: " (or dir default-directory)
                             nil t))))))

(defun my/cmake--dirs (ask)
  "(SORGENTI . BUILD) per i comandi CMake.
Con ASK chiede la directory dei sorgenti.  Errore se cmake manca
sull'host dei sorgenti o se la build sta su un altro host."
  (let* ((src (my/cmake--source-dir ask))
         (build (expand-file-name my/cmake-build-dir src)))
    (unless (equal (file-remote-p src) (file-remote-p build))
      (user-error "Sorgenti e build su host diversi: %s, %s" src build))
    (unless (let ((default-directory src))
              (executable-find "cmake" t))
      (user-error "cmake non trovato"))
    (cons src build)))

(defun my/cmake--quote (arg dir)
  "ARG quotato per un comando che gira in DIR.
Su un host remoto il quoting è POSIX anche da Emacs su Windows."
  (shell-quote-argument arg (file-remote-p dir)))

(defun my/cmake--quote-dir (dir src)
  "DIR per la riga di comando dei sorgenti SRC: locale (TRAMP) e quotata."
  (my/cmake--quote (file-local-name (directory-file-name dir)) src))

(defun my/cmake--compile (src command &rest args)
  "Esegue COMMAND con `compile' da SRC; ARGS (già quotati) per i %s."
  (let ((default-directory src))
    (compile (apply #'format command args))))

(defun my/cmake--presets-p (src)
  "Non-nil se i sorgenti SRC hanno CMakePresets.json o CMakeUserPresets.json."
  (or (file-exists-p (expand-file-name "CMakePresets.json" src))
      (file-exists-p (expand-file-name "CMakeUserPresets.json" src))))

(defun my/cmake--list-presets (src kind)
  "Nomi dei preset KIND (\"configure\" o \"build\") dei sorgenti SRC."
  (let ((default-directory src))
    (with-temp-buffer
      (unless (eq 0 (process-file "cmake" nil t nil
                                  (concat "--list-presets=" kind)))
        (user-error "cmake --list-presets=%s: %s" kind
                    (string-trim (buffer-string))))
      (goto-char (point-min))
      (let (names)
        (while (re-search-forward "^  \"\\([^\"]+\\)\"" nil t)
          (push (match-string 1) names))
        (nreverse names)))))

(defun my/cmake--preset (src kind ask)
  "Preset KIND per i sorgenti SRC.
Lo chiede con ASK o se non c'è una scelta valida da riusare: l'ultimo
preset KIND scelto (per la build, solo dopo l'ultima configure), poi
quello di configure omonimo, poi `my/cmake-preset'."
  (let* ((names (or (my/cmake--list-presets src kind)
                    (user-error "Nessun preset %s in %s" kind src)))
         (key (cons src kind))
         (default (seq-find
                   (lambda (n) (member n names))
                   (list (cdr (assoc key my/cmake--chosen-presets))
                         (cdr (assoc (cons src "configure")
                                     my/cmake--chosen-presets))
                         my/cmake-preset)))
         (name (if (and default (not ask))
                   default
                 (completing-read (format "Preset %s: " kind) names nil t
                                  nil nil (or default (car names))))))
    (setf (alist-get key my/cmake--chosen-presets nil nil #'equal) name)
    ;; Configure con un altro preset: la build non riusa quella vecchia.
    (when (equal kind "configure")
      (setf (alist-get (cons src "build") my/cmake--chosen-presets
                       nil t #'equal)
            nil))
    name))

(defun my/cmake--configured (dirs)
  "Errore se la build in (cdr DIRS) non è ancora configurata."
  (unless (file-exists-p (expand-file-name "CMakeCache.txt" (cdr dirs)))
    (user-error "Build non configurata in %s: prima C-c m c" (cdr dirs))))

(defun my/cmake-configure (&optional ask)
  "Configura con CMake: con i preset ne chiede uno, senza esporta
compile_commands.json per clangd.
Con \\[universal-argument] chiede la directory dei sorgenti."
  (interactive "P")
  (let* ((dirs (my/cmake--dirs ask))
         (src (car dirs)))
    (unless (file-exists-p (expand-file-name "CMakeLists.txt" src))
      (user-error "Nessun CMakeLists.txt in %s" src))
    (if (my/cmake--presets-p src)
        (my/cmake--compile src "cmake --preset %s"
                           (my/cmake--quote
                            (my/cmake--preset src "configure" t) src))
      (my/cmake--compile
       src "cmake -S %s -B %s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
       (my/cmake--quote-dir src src) (my/cmake--quote-dir (cdr dirs) src)))))

(defun my/cmake-build (&optional ask)
  "Compila la build CMake del progetto (con i preset, il preset di build).
Con \\[universal-argument] chiede la directory dei sorgenti e il preset."
  (interactive "P")
  (let* ((dirs (my/cmake--dirs ask))
         (src (car dirs)))
    (if (my/cmake--presets-p src)
        (my/cmake--compile src "cmake --build --preset %s -j"
                           (my/cmake--quote
                            (my/cmake--preset src "build" ask) src))
      (my/cmake--configured dirs)
      (my/cmake--compile src "cmake --build %s -j"
                         (my/cmake--quote-dir (cdr dirs) src)))))

(defun my/cmake-clean (&optional ask)
  "Pulisce la build CMake del progetto (con i preset, il preset di build).
Con \\[universal-argument] chiede la directory dei sorgenti e il preset."
  (interactive "P")
  (let* ((dirs (my/cmake--dirs ask))
         (src (car dirs)))
    (if (my/cmake--presets-p src)
        (my/cmake--compile src "cmake --build --preset %s --target clean"
                           (my/cmake--quote
                            (my/cmake--preset src "build" ask) src))
      (my/cmake--configured dirs)
      (my/cmake--compile src "cmake --build %s --target clean"
                         (my/cmake--quote-dir (cdr dirs) src)))))

(global-set-key (kbd "C-c m c") #'my/cmake-configure)
(global-set-key (kbd "C-c m b") #'my/cmake-build)

;; Hook per C e C++ (tree-sitter o classico, vedi treesit-config.el)
(defun my/c-setup ()
  "Eglot e tasti per C e C++."
  (my/eglot-ensure-if-found "clangd")
  ;; clang format when save c/c++ file
  ;; (add-hook 'before-save-hook #'clang-format-buffer nil t)

  ;; Keybindings specifici per C/C++
  (local-set-key (kbd "C-c o") 'ff-find-other-file)
  ;; Copre volutamente `comment-region' di cc-mode (resta M-;)
  (local-set-key (kbd "C-c C-c") 'compile)
  (local-set-key (kbd "C-c C-r") 'recompile)
  ;; Sotto il prefisso C-c m, che è anche quello dei comandi cmake (sopra)
  (local-set-key (kbd "C-c m m") 'man))

(add-hook 'c++-ts-mode-hook #'my/c-setup)
(add-hook 'c++-mode-hook #'my/c-setup)
(add-hook 'c-ts-mode-hook #'my/c-setup)
(add-hook 'c-mode-hook #'my/c-setup)

;; Configurazione Eglot per C e C++
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c++-ts-mode c++-mode c-ts-mode c-mode) . ("clangd"))))


;; (global-set-key (kbd "C-c m k") #'my/cmake-clean)
;; (global-set-key (kbd "C-c m r") #'recompile)

(provide 'c-config)
