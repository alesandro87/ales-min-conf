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

(provide 'bb-config)
