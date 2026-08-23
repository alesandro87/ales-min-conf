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

  (setq org-static-blog-publish-title    "Il quaderno di Atanasio")
  (setq org-static-blog-publish-url       "http://45.83.106.70/")
  (setq org-static-blog-publish-directory (expand-file-name "public/" ap/blog-path))
  (setq org-static-blog-posts-directory   (expand-file-name "posts/"  ap/blog-path))
  (setq org-static-blog-drafts-directory  (expand-file-name "drafts/" ap/blog-path))
  (setq org-static-blog-enable-tags t)
  (setq org-static-blog-use-preview t)
  (setq org-static-blog-preview-link-p t)

  (setq org-html-htmlize-output-type 'css)

  (setq org-static-blog-page-header
        (concat
         "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />\n"
         "<link rel=\"stylesheet\" href=\"/static/style.css\" type=\"text/css\" />"))

  ;; nav testuale (page-preamble) + evidenziazione voce attiva
  (setq org-static-blog-page-preamble
        (concat
         "<nav class=\"site-nav\">"
         "  <a href=\"/\">Home</a>"
         "  <a href=\"/chi-sono.html\">Chi sono</a>"
         "  <a href=\"/contatti.html\">Contatti</a>"
         "  <a href=\"/search.html\">Cerca</a>"
         "</nav>"
         "<script>"
         "document.querySelectorAll('.site-nav a').forEach(function(a){"
         "  if(a.getAttribute('href')===location.pathname)a.classList.add('active');"
         "});"
         "</script>"))

  ;; footer minimo (page-postamble) + rilevamento pagina di singolo
  ;; articolo (un solo .post-title dentro #content) per il layout a
  ;; due colonne; nella home/archivio/tag ce ne sono piu' di uno.
  (setq org-static-blog-page-postamble
        (concat
         "Il quaderno di Atanasio &middot; <a href=\"/rss.xml\">RSS</a> &middot; &#169; 2026"
         "<script>"
         "(function(){"
         "  var c = document.getElementById('content');"
         "  var first = c && c.firstElementChild;"
         "  var isHome = location.pathname === '/' || location.pathname === '/index.html';"
         "  var isListPage = first && first.matches('h1.title');"
         "  if(isHome){ document.body.classList.add('home-page'); }"
         "  if(c && !isHome && !isListPage && c.querySelectorAll('.post-title').length === 1){"
         "    document.body.classList.add('article-page');"
         "  }"
         "})();"
         "</script>")))

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

(defun ap/blog-generate-search-index ()
  "Genera search-index.json nella directory di pubblicazione."
  (interactive)
  (let* ((files (org-static-blog-get-post-filenames))
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
    (message "Indice di ricerca generato: %d post." (length index))))

;; ---- Pubblicazione e deploy ----------------------------------------------

(defun ap/blog-deploy ()
  "Rigenera il blog, l'indice di ricerca, e sincronizza sul VPS."
  (interactive)
  (when ap/blog-config-file
    (load ap/blog-config-file))  ;; ricarica sempre la config prima di pubblicare
  (org-static-blog-publish t)  ;; forza la rigenerazione di tutti i post
  (ap/blog-generate-search-index)
  (message "Pubblico da: %s" org-static-blog-publish-directory)
  (shell-command
   (format "rsync -avz --delete %s ales@45.83.106.70:/var/www/blog/"
           (shell-quote-argument org-static-blog-publish-directory))
   "*blog-deploy*")
  (message "Blog pubblicato. Dettagli in *blog-deploy*."))

(provide 'blog-config)
;;; blog-config.el ends here
