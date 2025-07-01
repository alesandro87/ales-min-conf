;;; post-early-init.el --- Setup iniziale cross-platform -*- lexical-binding: t; no-byte-compile: t; -*-

;; Directory per configurazioni personalizzate
(defvar my/config-dir (expand-file-name "ales-min-conf/config/" user-emacs-directory)
  "Directory per le configurazioni modulari.")

;; Crea la directory se non esiste
(unless (file-directory-p my/config-dir)
  (make-directory my/config-dir t))

;; Funzione helper per caricare file di configurazione
(defun my/load-config (filename)
  "Carica un file di configurazione dalla directory config/."
  (let ((file (expand-file-name filename my/config-dir)))
    (when (file-exists-p file)
      (load file))))

;; Repository pacchetti - configurazione comune
;;(require 'package)
;;(setq package-archives
;;      '(("gnu" . "https://elpa.gnu.org/packages/")
;;        ("melpa" . "https://melpa.org/packages/")
;;        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;; Ottimizzazioni GC comuni
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
