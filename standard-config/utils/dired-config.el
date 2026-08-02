;; In locale: switch GNU, con group-directories-first
(setq dired-listing-switches "-ahl --group-directories-first")

;; Su host remoti BSD (FreeBSD): niente opzioni GNU-only
(connection-local-set-profile-variables
 'remote-bsd-dired
 '((dired-listing-switches . "-ahl")))

(connection-local-set-profiles
 '(:application tramp :protocol "ssh" :machine "saturno.lan")
 'remote-bsd-dired)

(provide 'dired-config)
