;; add
;; create file
;; in ~/.config/environment.d/getoutline_api_key.conf
;; systemctl --user show-environment

;; Sviluppo locale: metti a `t` mentre editi il pacchetto in place.
;; Metti a `nil` per installarlo dal repo remoto via :vc.
(defvar getoutline-use-local-path nil)

(if getoutline-use-local-path
    (use-package getoutline
      :load-path "/home/ales/Work/Projects/getoutline"
      :ensure nil
      :config
      (setq getoutline-url "http://192.168.0.99:4000"   ; il tuo Outline
            getoutline-api-token (getenv "OUTLINE_API_TOKEN")))

  ;; else 
  (use-package getoutline
    :vc (:url "git@github.com:alesandro87/getoutline.git"
              :branch dev
              :rev :newest)
    :config
    (setq getoutline-url "http://192.168.0.99:4000"
          getoutline-api-token (getenv "OUTLINE_API_TOKEN"))))

(provide 'getoutline-config)
