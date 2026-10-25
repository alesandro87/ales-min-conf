;;; bb-config.el -*- lexical-binding: t; -*-
(use-package bb-mode
  :ensure nil   ; file locale in standard-config/mode/, non su ELPA
  :mode (("\\.bb\\'"       . bb-mode)
         ("\\.bbappend\\'" . bb-mode)
         ("\\.bbclass\\'"  . bb-mode)
         ;; .conf e .inc: associazione euristica basata sui percorsi Yocto
         ("/conf/\\(?:local\\|bblayers\\|layer\\|site\\|auto\\|bitbake\\)\\.conf\\'" . bb-mode)
         ("/conf/\\(?:machine\\|distro\\|multiconfig\\)/[^/]+\\.conf\\'" . bb-mode)
         ("/meta\\(?:-[^/]+\\)?/.*\\.inc\\'" . bb-mode)))

;; bb-mode deriva da fundamental-mode, non da prog-mode: parentesi e numeri
;; di riga (ales-config.el) vanno attivati a parte
(add-hook 'bb-mode-hook #'electric-pair-local-mode)
(add-hook 'bb-mode-hook #'display-line-numbers-mode)

(provide 'bb-config)
