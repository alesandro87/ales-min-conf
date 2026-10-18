;;; c-config.el -*- lexical-binding: t; -*-
(declare-function my/eglot-ensure-if-found "eglot-config" (&rest programs))
(use-package cc-mode
  :ensure t
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

(add-hook 'before-save-hook
          (lambda ()
            (when (and (bound-and-true-p auto-format-on-save)
                       (bound-and-true-p eglot--managed-mode))
              (eglot-format-buffer))))
;;;

;; Configurazione per CMake
(use-package cmake-mode
  :ensure t
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

;;; Comandi CMake: sorgenti nella radice del progetto (project.el) o in
;;; `my/cmake-source-dir', build in `my/cmake-build-dir'.  La configure
;;; esporta sempre compile_commands.json per clangd; con il generatore
;;; Visual Studio (default su Windows) CMake lo ignora e clangd resta
;;; senza database.
(declare-function project-root "project" (project))

(defvar my/cmake-source-dir nil
  "Directory dei sorgenti CMake, con il CMakeLists.txt principale.
Nil = radice del progetto.  Relativa alla radice del progetto o
assoluta; si imposta per progetto in .dir-locals.el.")

(defvar my/cmake-build-dir "build"
  "Directory di build, relativa alla directory dei sorgenti CMake.
\"build\" clangd la trova da solo; con un altro nome serve un .clangd
nei sorgenti con `CompilationDatabase: <nome>'.")

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

(defun my/cmake--quote (dir)
  "DIR per la riga di comando: locale (TRAMP) e quotata.
Su un host remoto il quoting è POSIX anche da Emacs su Windows."
  (shell-quote-argument (file-local-name (directory-file-name dir))
                        (file-remote-p dir)))

(defun my/cmake--compile (dir command &rest dirs)
  "Esegue COMMAND con `compile' da DIR; DIRS sostituiscono i %s, quotate."
  (let ((default-directory dir))
    (compile (apply #'format command (mapcar #'my/cmake--quote dirs)))))

(defun my/cmake--configured (dirs)
  "Errore se la build in (cdr DIRS) non è ancora configurata."
  (unless (file-exists-p (expand-file-name "CMakeCache.txt" (cdr dirs)))
    (user-error "Build non configurata in %s: prima C-c m c" (cdr dirs))))

(defun my/cmake-configure (&optional ask)
  "Configura con CMake ed esporta compile_commands.json per clangd.
Con \\[universal-argument] chiede la directory dei sorgenti."
  (interactive "P")
  (let ((dirs (my/cmake--dirs ask)))
    (unless (file-exists-p (expand-file-name "CMakeLists.txt" (car dirs)))
      (user-error "Nessun CMakeLists.txt in %s" (car dirs)))
    (my/cmake--compile (car dirs)
                       "cmake -S %s -B %s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
                       (car dirs) (cdr dirs))))

(defun my/cmake-build (&optional ask)
  "Compila la build CMake del progetto.
Con \\[universal-argument] chiede la directory dei sorgenti."
  (interactive "P")
  (let ((dirs (my/cmake--dirs ask)))
    (my/cmake--configured dirs)
    (my/cmake--compile (car dirs) "cmake --build %s -j" (cdr dirs))))

(defun my/cmake-clean (&optional ask)
  "Pulisce la build CMake del progetto.
Con \\[universal-argument] chiede la directory dei sorgenti."
  (interactive "P")
  (let ((dirs (my/cmake--dirs ask)))
    (my/cmake--configured dirs)
    (my/cmake--compile (car dirs) "cmake --build %s --target clean"
                       (cdr dirs))))

(global-set-key (kbd "C-c m c") #'my/cmake-configure)
(global-set-key (kbd "C-c m b") #'my/cmake-build)

;; Hook per C e C++ (tree-sitter o classico, vedi treesit-config.el)
(defun my/cpp-mode-hook ()
  "Hook personalizzato per C e C++"
  (my/eglot-ensure-if-found "clangd")
  ;; Parentesi automatiche attive all'apertura di un file C/C++, anche se
  ;; spente globalmente; solo in questo buffer.
  (electric-pair-local-mode 1)
  ;; clang format when save c/c++ file
  ;; (add-hook 'before-save-hook #'clang-format-buffer nil t)

  ;; Keybindings specifici per C/C++
  (local-set-key (kbd "C-c o") 'ff-find-other-file)
  (local-set-key (kbd "C-c C-c") 'compile)
  (local-set-key (kbd "C-c C-r") 'recompile)
  ;; Sotto il prefisso C-c m, che è anche quello dei comandi cmake (sopra)
  (local-set-key (kbd "C-c m m") 'man))

(add-hook 'c++-ts-mode-hook 'my/cpp-mode-hook)
(add-hook 'c++-mode-hook 'my/cpp-mode-hook)
(add-hook 'c-ts-mode-hook 'my/cpp-mode-hook)
(add-hook 'c-mode-hook 'my/cpp-mode-hook)

;; Configurazione Eglot per C e C++
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c++-ts-mode c++-mode c-ts-mode c-mode) . ("clangd"))))


;; (global-set-key (kbd "C-c m k") #'my/cmake-clean)
;; (global-set-key (kbd "C-c m r") #'recompile)

(provide 'c-config)
