;;; blog-config.el --- Blog (org-static-blog + tema Spartano/Fowler) -*- lexical-binding: t; -*-

;; Tema "Spartano" alla Martin Fowler: carta calda, accento
;; petrolio, corpo serif, nav testuale, footer minimo. Solo chiaro.
;; Sostituisci host/percorsi/utente con i tuoi.

;;; Code:

(require 'json)

(defvar ap/blog-config-file (or load-file-name (buffer-file-name))
  "Percorso di questo file: permette a ap/blog-deploy di ricaricarlo
da solo prima di pubblicare, cosi' una modifica salvata ma non
ancora rivalutata non finisce mai silenziosamente in produzione.")

(defvar ap/blog-path
  (or (getenv "ATANASIO_BLOG_PATH") "~/blog")
  "Cartella radice del blog (posts/, drafts/, public/).")

(defvar ap/blog-templates-directory
  (expand-file-name "emacs/templates/" ap/blog-path)
  "Cartella dei frammenti HTML/JS puri (nav, footer, script di
rilevamento pagina, intro home) usati per comporre le variabili
org-static-blog-page-*. Ancorata a ap/blog-path (il repo del blog),
non alla posizione di blog-config.el: quest'ultimo puo' vivere altrove
(es. dentro la config Emacs dell'utente). Non fa parte di public/: non
viene mai pubblicata sul VPS, e' solo sorgente letta a tempo di config.")

(defun ap/blog--language-title (code)
  "Legge il titolo del sito per la lingua CODE (es. \"it\"/\"en\") da
emacs/templates/CODE/title.txt: file di progetto, non stringa Lisp in
blog-config.el, cosi' il titolo si modifica editando quel file (come
nav/footer/intro) invece della config Emacs. Usata sia da
org-static-blog (via ap/blog--publish-language) sia per sostituire
{{SITE_TITLE}} nei template (via ap/blog--read-template)."
  (let ((dir (expand-file-name (file-name-as-directory code)
                                ap/blog-templates-directory)))
    (with-temp-buffer
      (insert-file-contents (expand-file-name "title.txt" dir))
      (string-trim (buffer-string)))))

(defun ap/blog--read-template (filename &optional lang)
  "Legge FILENAME da ap/blog-templates-directory come stringa.
Se LANG e' dato (es. \"it\"/\"en\"), legge dalla sua sottocartella
(nav/footer/intro sono per lingua); i file condivisi fra le lingue
(nav-active.js, page-detect.js) restano nella cartella principale,
quindi si chiamano senza LANG. Quando LANG e' dato, sostituisce anche
{{SITE_TITLE}} col contenuto di title.txt di quella lingua (vedi
ap/blog--language-title), cosi' il titolo del sito vive in un solo
file di progetto invece di essere riscritto a mano in ogni template."
  (let* ((dir (if lang
                  (expand-file-name (file-name-as-directory lang)
                                     ap/blog-templates-directory)
                ap/blog-templates-directory))
         (content (with-temp-buffer
                    (insert-file-contents (expand-file-name filename dir))
                    (string-trim (buffer-string)))))
    (if lang
        (replace-regexp-in-string (regexp-quote "{{SITE_TITLE}}")
                                   (ap/blog--language-title lang)
                                   content t t)
      content)))

(defvar ap/blog-languages
  (list
   (list :code "it"
         :posts-directory   (expand-file-name "posts/it/"  ap/blog-path)
         :drafts-directory  (expand-file-name "drafts/it/" ap/blog-path)
         :publish-directory (expand-file-name "public/"    ap/blog-path)
         :publish-url       "http://45.83.106.70/")
   (list :code "en"
         :posts-directory   (expand-file-name "posts/en/"  ap/blog-path)
         :drafts-directory  (expand-file-name "drafts/en/" ap/blog-path)
         :publish-directory (expand-file-name "public/en/" ap/blog-path)
         :publish-url       "http://45.83.106.70/en/"))
  "Una voce per lingua pubblicata dal blog.
public/ (it) resta la root del sito; le altre lingue pubblicano in una
sottocartella di public/ (es. public/en/): un solo rsync di public/
(vedi ap/blog-deploy) le porta quindi tutte sul VPS in un solo deploy,
senza bisogno di sincronizzare lingua per lingua. static/ (CSS, foto)
e' condiviso fra tutte: i link nei template sono assoluti (/static/...)
e risolvono correttamente anche dentro le sottocartelle di lingua. Il
titolo non e' qui: vive in emacs/templates/<code>/title.txt (vedi
ap/blog--language-title), non in questa config Emacs.")

(use-package htmlize
  :ensure t
  :demand t)

(use-package simple-httpd
  :ensure t
  :defer t
  :config
  (setq httpd-port 8080)
  (setq httpd-root (expand-file-name "public/" ap/blog-path)))

(use-package org-static-blog
  :ensure t
  :config

  (setq org-static-blog-publish-title    (ap/blog--language-title "it"))
  (setq org-static-blog-publish-url       "http://45.83.106.70/")
  (setq org-static-blog-publish-directory (expand-file-name "public/" ap/blog-path))
  (setq org-static-blog-posts-directory   (expand-file-name "posts/it/"  ap/blog-path))
  (setq org-static-blog-drafts-directory  (expand-file-name "drafts/it/" ap/blog-path))
  (setq org-static-blog-enable-tags t)
  (setq org-static-blog-use-preview t)
  (setq org-static-blog-preview-link-p t)

  (setq org-html-htmlize-output-type 'css)

  (setq org-static-blog-page-header
        (concat
         "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />\n"
         "<link rel=\"stylesheet\" href=\"/static/style.css\" type=\"text/css\" />"))

  ;; Valori di default (lingua "it"): usati per l'uso interattivo,
  ;; es. M-x org-static-blog-create-new-post o M-x httpd-start mentre
  ;; scrivi. ap/blog-deploy li sovrascrive temporaneamente per lingua
  ;; (vedi ap/blog--publish-language), poi tornano a questi.

  ;; introduzione in cima alla home, prima della lista dei post
  ;; (org-static-blog inserisce questo HTML solo su index.html,
  ;; non sulle altre pagine multipost come archive/tag).
  (setq org-static-blog-index-front-matter
        (ap/blog--read-template "intro.html" "it"))

  ;; nav testuale (page-preamble) + evidenziazione voce attiva
  (setq org-static-blog-page-preamble
        (concat
         (ap/blog--read-template "nav.html" "it")
         "<script>" (ap/blog--read-template "nav-active.js") "</script>"))

  ;; footer minimo (page-postamble) + rilevamento pagina di singolo
  ;; articolo (un solo .post-title dentro #content) per il layout a
  ;; due colonne; nella home/archivio/tag ce ne sono piu' di uno.
  (setq org-static-blog-page-postamble
        (concat
         (ap/blog--read-template "footer.html" "it")
         "<script>" (ap/blog--read-template "page-detect.js") "</script>")))

;; ---- Ricerca full-text ----------------------------------------------------

;; Genera search-index.json nella directory di pubblicazione, letto poi
;; dalla pagina search.html per la ricerca lato client (nessun server).
;; Cerca in titolo, tag e corpo del post; il contenuto dei blocchi di
;; codice resta indicizzato, cosi' si puo' cercare anche nel codice.

(defun ap/blog--file-to-plaintext (file)
  "Estrae il testo semplice di FILE per l'indice di ricerca.
Rimuove le righe di metadati e i delimitatori #+... (incluso
begin_src/end_src), risolve i link org alla loro descrizione e
normalizza gli spazi. Il testo dentro i blocchi di codice resta."
  (with-temp-buffer
    (insert-file-contents file)
    ;; via tutte le righe che iniziano con #+ (metadati + fence dei src block)
    (goto-char (point-min))
    (flush-lines "^[ \t]*#\\+")
    ;; link [[url][descr]] -> descr
    (goto-char (point-min))
    (while (re-search-forward "\\[\\[\\(?:.*?\\)\\]\\[\\(.*?\\)\\]\\]" nil t)
      (replace-match "\\1"))
    ;; link [[url]] -> url
    (goto-char (point-min))
    (while (re-search-forward "\\[\\[\\(.*?\\)\\]\\]" nil t)
      (replace-match "\\1"))
    ;; normalizza gli spazi bianchi
    (goto-char (point-min))
    (while (re-search-forward "[ \t\n\r]+" nil t)
      (replace-match " "))
    (string-trim (buffer-string))))

(defun ap/blog--draft-filenames ()
  "Elenco dei file .org in org-static-blog-drafts-directory (le pagine,
es. chi-sono/contatti/progetti). org-static-blog-get-post-filenames
guarda solo posts-directory, quindi senza questa aggiunta le pagine
restano sempre fuori dall'indice di ricerca."
  (when (file-directory-p org-static-blog-drafts-directory)
    (directory-files org-static-blog-drafts-directory t "\\.org\\'")))

(defun ap/blog-generate-search-index ()
  "Genera search-index.json nella directory di pubblicazione."
  (interactive)
  (let* ((files (append (org-static-blog-get-post-filenames)
                         (ap/blog--draft-filenames)))
         (index
          (mapcar
           (lambda (file)
             (let* ((text (ap/blog--file-to-plaintext file))
                    (excerpt (if (> (length text) 200)
                                 (concat (substring text 0 200) "…")
                               text)))
               (list (cons 'title   (org-static-blog-get-title file))
                     (cons 'url     (org-static-blog-get-post-url file))
                     (cons 'date    (format-time-string
                                     "%Y-%m-%d" (org-static-blog-get-date file)))
                     (cons 'tags    (org-static-blog-get-tags file))
                     (cons 'excerpt excerpt)
                     (cons 'text    text))))
           files)))
    (with-temp-file (expand-file-name "search-index.json"
                                      org-static-blog-publish-directory)
      (insert (json-encode index)))
    (message "Indice di ricerca generato: %d voci." (length index))))

;; ---- Pubblicazione e deploy ----------------------------------------------

(defun ap/blog--publish-language (lang)
  "Pubblica una voce LANG di ap/blog-languages: rilega temporaneamente
le variabili org-static-blog-* (posts/drafts/publish-directory/-url/
-title) e i template nav/footer/intro sulla lingua di LANG, poi
rigenera il sito e il suo indice di ricerca. Il let ripristina i
valori precedenti (quelli \"it\" di default) appena finisce, quindi le
lingue non si sporcano a vicenda anche pubblicandole in sequenza."
  (let* ((code    (plist-get lang :code))
         (org-static-blog-posts-directory   (plist-get lang :posts-directory))
         (org-static-blog-drafts-directory  (plist-get lang :drafts-directory))
         (org-static-blog-publish-directory (plist-get lang :publish-directory))
         (org-static-blog-publish-url       (plist-get lang :publish-url))
         (org-static-blog-publish-title     (ap/blog--language-title code))
         (org-static-blog-page-preamble
          (concat (ap/blog--read-template "nav.html" code)
                  "<script>" (ap/blog--read-template "nav-active.js") "</script>"))
         (org-static-blog-page-postamble
          (concat (ap/blog--read-template "footer.html" code)
                  "<script>" (ap/blog--read-template "page-detect.js") "</script>"))
         (org-static-blog-index-front-matter
          (ap/blog--read-template "intro.html" code)))
    (unless (file-directory-p org-static-blog-publish-directory)
      (make-directory org-static-blog-publish-directory t))
    (org-static-blog-publish t)  ;; forza la rigenerazione di tutti i post
    (ap/blog-generate-search-index)
    (message "Lingua \"%s\" pubblicata in: %s" code org-static-blog-publish-directory)))

(defun ap/blog-deploy ()
  "Rigenera il blog in tutte le lingue di ap/blog-languages, l'indice
di ricerca di ciascuna, e sincronizza public/ sul VPS in un solo
passo (le lingue diverse da \"it\" pubblicano gia' dentro una
sottocartella di public/, quindi un solo rsync le porta tutte)."
  (interactive)
  (when ap/blog-config-file
    (load ap/blog-config-file))  ;; ricarica sempre la config prima di pubblicare
  (mapc #'ap/blog--publish-language ap/blog-languages)
  (let ((root (expand-file-name "public/" ap/blog-path)))
    (message "Pubblico da: %s (tutte le lingue)" root)
    (shell-command
     (format "rsync -avz --delete %s ales@45.83.106.70:/var/www/blog/"
             (shell-quote-argument root))
     "*blog-deploy*"))
  (message "Blog pubblicato (tutte le lingue). Dettagli in *blog-deploy*."))

(provide 'blog-config)
;;; blog-config.el ends here
