;; add
;; create file 
;; in ~/.config/environment.d/getoutline_api_key.conf
;; with 



(use-package getoutline
  :vc (:url "git@github.com:alesandro87/getoutline.git"
            :branch dev
            :rev :newest)
  :config
  (setq getoutline-url "http://192.168.0.99:4000"   ; il tuo Outline
        getoutline-api-token (getenv "OUTLINE_API_TOKEN")))

(provide 'getoutline-config)
