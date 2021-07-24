;; Preamble
;;   :PROPERTIES:
;;   :ID:       20210326T232652.733571
;;   :END:

;; This is the [[id:b69228c3-14fe-41f9-bfdb-e5e34d7c2a9b][literate configuration]] source for my [[id:b529d37d-becd-495d-be37-dd91a4dc039b][spacemacs]] user config.  I use [[id:d0cfbb57-33fe-4715-932f-a34128c3f782][org-babel]] to tangle it together into the actual config file.


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; GENERATED FROM USER-CONFIG.ORG - DON'T EDIT THIS DIRECTLY!
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set up keyboard shortcuts for PHPUnit
;;     :PROPERTIES:
;;     :ID:       20210326T232652.754586
;;     :END:

  (with-eval-after-load 'php-mode
    (define-key php-mode-map (kbd "C-c C-t t") 'phpunit-current-test)
    (define-key php-mode-map (kbd "C-c C-t c") 'phpunit-current-class)
    (define-key php-mode-map (kbd "C-c C-t p") 'phpunit-current-project))

;; Use web-mode for Laravel templates.
;;     :PROPERTIES:
;;     :ID:       20210326T232652.758318
;;     :END:

  (add-to-list 'auto-mode-alist '("\\.blade.php\\'" . web-mode))

;; Use org-super-agenda a nicer looking agenda.
;;      :PROPERTIES:
;;      :ID:       20210326T232652.763253
;;      :END:

  (org-super-agenda-mode)
  (setq org-agenda-custom-commands
        '(("g" "Super groups"
           agenda ""
           ((org-super-agenda-groups
             '((:auto-property "agenda-group")))))
          ("u" "Super view"
           agenda ""
           ((org-super-agenda-groups
             '(;; Each group has an implicit boolean OR operator between its selectors.
               (:name "Today"  ; Optionally specify section name
                      :time-grid t  ; Items that appear on the time grid
                      :tag "today"
                      :todo "TODAY")  ; Items that have this TODO keyword
               (:name "Important"
                      ;; Single arguments given alone
                      :tag "bills"
                      :priority "A")
               ;; Set order of multiple groups at once
               (:name "Quick wins (< 20 mins)"
                      :effort< "0:20")
               (:name "Cleaning"
                      :tag "cleaning"
                      :order 5)
               (:name "Chores"
                      :tag "chore"
                      :order 5)
               (:name "Stuck"
                      :tag "stuck"
                      :order 2)
               (:name "Town"
                      :tag ("town" "@town")
                      :order 9)
               (:order-multi (2 (:name "Shopping in town"
                                       ;; Boolean AND group matches items that match all subgroups
                                       :and (:tag "shopping" :tag "@town"))
                                ;;(:name "Personal"
                                ;;       :habit t
                                ;;       :tag "personal")
                                (:name "Food-related"
                                       ;; Multiple args given in list with implicit OR
                                          :tag ("food" "dinner"))))
                  ;; Groups supply their own section names when none are given
                  (:todo "WAITING" :order 8)  ; Set order of this section
                  (:todo ("SOMEDAY" "TO-READ" "CHECK" "TO-WATCH" "WATCHING")
                        ;; Show this group at the end of the agenda (since it has the
                        ;; highest number). If you specified this group last, items
                        ;; with these todo keywords that e.g. have priority A would be
                        ;; displayed in that group instead, because items are grouped
                        ;; out in the order the groups are listed.
                        :order 9)
                  (:priority<= "B"
                              ;; Show this section after "Today" and "Important", because
                              ;; their order is unspecified, defaulting to 0. Sections
                              ;; are displayed lowest-number-first.
                              :order 3)
                  ;; After the last group, the agenda will display items that didn't
                  ;; match any of these groups, with the default order position of 99
                  ))))))

;; capture templates
;;      :PROPERTIES:
;;      :ID:       20210326T232652.768075
;;      :END:

   (require 'org-protocol)
   ;(add-to-list 'load-path "/home/neil/.emacs.d/private/org-protocol-capture-html")
   ;(require 'org-protocol-capture-html)

   (setq org-capture-templates
         (quote
          (("c" "TODO scheduled today"
            entry (file+headline "~/org/_GTD.org" "Inbox")
            "** TODO %?\n SCHEDULED: %t\n")
           ;; ("w" "Web site"
           ;;  entry (file+olp "/home/shared/commonplace/clippings.org" "Clippings")
           ;;  "** %c :website:\n%U %?%:initial")
           )))

   ;; to start in insert mode when creating via capture template
   (add-hook 'org-capture-mode-hook 'evil-insert-state)

;; Refiling
;;     :PROPERTIES:
;;     :ID:       20210326T232652.772169
;;     :END:
   

   (setq org-refile-targets '((nil :maxlevel . 9)
                              (org-agenda-files :maxlevel . 9)))
   (setq org-outline-path-complete-in-steps nil)         ; Refile in a single go
   (setq org-refile-use-outline-path t)                  ; Show full paths for refiling

;; Babel
;;     :PROPERTIES:
;;     :ID:       20210326T232652.776075
;;     :END:

;; babel
(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((sql . t)
     (python . t)
     (plantuml . t)
     (sqlite . t)
     (shell . t))))



;; Without this, the indentation in org-babel src blocks always gets indented without me wanting it to.  See: https://github.com/syl20bnr/spacemacs/issues/13255


(setq org-src-preserve-indentation t)

;; Deleting links
;;      :PROPERTIES:
;;      :ID:       20210326T232652.785621
;;      :END:
;; See: https://emacs.stackexchange.com/questions/10707/in-org-mode-how-to-remove-a-link

   (defun ngm/org-delete-link ()
     "Replace an org link of the format [[LINK][DESCRIPTION]] with DESCRIPTION.
       If the link is of the format [[LINK]], delete the whole org link.

       In both the cases, save the LINK to the kill-ring.

       Execute this command while the point is on or after the hyper-linked org link."
     (interactive)
     (when (derived-mode-p 'org-mode)
       (let ((search-invisible t) start end)
         (save-excursion
           (when (re-search-backward "\\[\\[" nil :noerror)
             (when (re-search-forward "\\[\\[\\(.*?\\)\\(\\]\\[.*?\\)*\\]\\]" nil :noerror)
               (setq start (match-beginning 0))
               (setq end   (match-end 0))
               (kill-new (match-string-no-properties 1)) ; Save the link to kill-ring
               (replace-regexp "\\[\\[.*?\\(\\]\\[\\(.*?\\)\\)*\\]\\]" "\\2" nil start end)))))))

;; org-timeline
;;      :PROPERTIES:
;;      :ID:       20210326T232652.790249
;;      :END:

     (require 'org-timeline)
     (add-hook 'org-agenda-finalize-hook 'org-timeline-insert-timeline :append)

;; Writing and knowledge management
;;   :PROPERTIES:
;;   :ID:       20210326T232652.794077
;;   :END:

;;    I do my writing mostly in org-journal and org-roam.
   

  (setq org-journal-file-format "%Y-%m-%d.org")

;; Writing mode
;;    :PROPERTIES:
;;    :ID:       20210326T232652.798196
;;    :END:

;;    A couple of customisations to make writing prose a nice experience.
   

    (defun ngm-visual-line-motion ()
      "So j and k move up and down more like you'd expect in visual line mode"
      (interactive)
      (define-key evil-motion-state-map "j" 'evil-next-visual-line)
      (define-key evil-motion-state-map "k" 'evil-previous-visual-line))

    (defun ngm-journal-mode ()
      "Set up journalling mode the way that I like it"
      (interactive)
      (olivetti-mode)
      (variable-pitch-mode 1)
      (face-remap-add-relative 'variable-pitch '(:family "Roboto Slab" :height 140))
      (ngm-visual-line-motion)
      (setq company-backends '(company-capf)) ; for org-roam completion
      )

;; Misc

    

  (setq org-roam-dailies-directory "journal")

;; Load my helper files


(load "~/.emacs.d/private/commonplace-lib/commonplace-lib.el")

;; Linking to other files

;;     Because I use export heavily, I'm kind of dependent on file-based links right now (as far as I understand).  This is going to be problematic when org-roam v2 rolls around, but cross that bridge when we come to it.


(setq org-roam-prefer-id-links t)

;; Prefer immediate DB update method.
;;     :PROPERTIES:
;;     :ID:       20210326T232652.802602
;;     :END:

;; This updates the DB on save, rather than on an idle timer.  I was finding idle timer frustrating, as the unexpected DB update interrupted my flow.  Updating on save works better for me, as I tend to pause momentarily after a save anyway, as I usually save at the end of a sentence.

  (setq org-roam-db-update-method 'immediate)

;; Wikilink syntax for adding links
;;     :PROPERTIES:
;;     :ID:       20210326T232652.807056
;;     :END:

;; For inserting links to other wiki pages more quickly, essentially with wikilink syntax.
;; See: [[id:6ca4da04-ae16-4ac7-825b-f06b77939ac6][Using fuzzy links AKA wikilinks in org-roam]].

  (require 'key-chord)
  (key-chord-mode 1)
  (key-chord-define org-mode-map "[[" #'ngm/insert-roam-link)

  (defun ngm/insert-roam-link ()
    "Inserts an Org-roam link."
    (interactive)
    (insert "[[roam:]]")
    (backward-char 2))

;; Tags
;;     :PROPERTIES:
;;     :ID:       20210326T232652.811020
;;     :END:

  (setq org-roam-tag-sources '(prop last-directory))

;; org-roam capture templates
;;     :PROPERTIES:
;;     :ID:       20210326T232652.815610
;;     :END:

;;     Add CREATED and LAST_MODIFIED properties to the new note.

(setq org-roam-capture-templates '(("d" "default" plain "%?"
                                    :if-new (file+head "${slug}.org"
                                                       "#+title: ${title}\n#+CREATED: %u\n#+LAST_MODIFIED: %U")
                                    :unnarrowed t)))
  ;; (setq org-roam-capture-templates
  ;;       '(("d" "default" plain (function org-roam--capture-get-point)
  ;;           "%?"
  ;;           :file-name "${slug}"
  ;;           :head "#+title: ${title}\n#+CREATED: %U\n#+LAST_MODIFIED: %U\n\n"
  ;;           :unnarrowed t)))

  ;; (setq org-roam-dailies-capture-templates '(("d" "daily" plain (function org-roam-capture--get-point) ""
  ;;                                             :immediate-finish t
  ;;                                             :file-name "journal/%<%Y-%m-%d>"
  ;;                                             :head "#+TITLE: %<%Y-%m-%d>")))

;; Updating timestamps on save
;;     :PROPERTIES:
;;     :ID:       20210326T232652.820294
;;     :END:

;;     I would prefer to do this on org-roam files only.
;;     See  [[https://org-roam.discourse.group/t/update-a-field-last-modified-at-save/321/19][Update a field (#+LAST_MODIFIED: ) at save - How To - Org-roam]].
;;     Doesn't seem to work though.

  (setq time-stamp-active t
        time-stamp-start "#\\+LAST_MODIFIED:[ \t]*"
        time-stamp-end "$"
        time-stamp-format "\[%Y-%02m-%02d %3a %02H:%02M\]")
  (add-hook 'before-save-hook 'time-stamp nil)

;; Graph settings
;;     :PROPERTIES:
;;     :ID:       20210326T232652.824834
;;     :END:

;; Exclude some of the big files from the graph.

  (setq org-roam-graph-exclude-matcher '("sitemap" "index" "recentchanges"))

;; org-roam-server
;;     :PROPERTIES:
;;     :ID:       20210326T232652.829175
;;     :END:

;; org-roam-protocol is needed to be able to click on nodes and have the corresponding file load in Emacs.


(require 'org-roam-protocol)



;; Try and speed things up a bit.  Things are *much* faster to render for me if I turn off vis.js's physics - but they resulting view is more cluttered unfortunately.  But it's kind of unusable with the physics on.


(setq org-roam-server-network-poll nil)
(setq org-roam-server-network-vis-options (json-encode (list (cons 'physics (list (cons 'enabled json-false))))))

(setq org-roam-server-default-exclude-filters "[{ \"tags\": \"journal\", \"id\" : \"Recent changes\", \"id\":\"recentchanges\"  }]")

;; dailies




;; Themes
;;    :PROPERTIES:
;;    :ID:       20210326T232652.841598
;;    :END:

    (doom-themes-treemacs-config)
    (doom-themes-org-config)

;; Solaire
;;    :PROPERTIES:
;;    :ID:       20210326T232652.845889
;;    :END:
   
;; See https://github.com/hlissner/emacs-solaire-mode

;; This appears to have been updated and I need to do something

  ;;(require 'solaire-mode)
  ;; Enable solaire-mode anywhere it can be enabled
  ;; (solaire-global-mode +1)
  ;; ;; To enable solaire-mode unconditionally for certain modes:
  ;; (add-hook 'ediff-prepare-buffer-hook #'solaire-mode)

  ;; ;; ...if you use auto-revert-mode, this prevents solaire-mode from turning
  ;; ;; itself off every time Emacs reverts the file
  ;; (add-hook 'after-revert-hook #'turn-on-solaire-mode)

  ;; ;; highlight the minibuffer when it is activated:
  ;; ;(add-hook 'minibuffer-setup-hook #'solaire-mode-in-minibuffer)

  ;; ;; if the bright and dark background colors are the wrong way around, use this
  ;; ;; to switch the backgrounds of the `default` and `solaire-default-face` faces.
  ;; ;; This should be used *after* you load the active theme!
  ;; ;;
  ;; ;; NOTE: This is necessary for themes in the doom-themes package!
  ;; (solaire-mode-swap-bg)

;; Tabs (centaur)
;;    :PROPERTIES:
;;    :ID:       20210326T232652.850925
;;    :END:
   
;;    Not currently using this, as I think it broke something.

  ;; centaur-tabs configuration
  ;; https://github.com/ema2159/centaur-tabs
                                        ;(require 'centaur-tabs)
                                        ;(centaur-tabs-mode t)
                                        ;(global-set-key (kbd "C-<prior>")  'centaur-tabs-backward)
                                        ;(global-set-key (kbd "C-<next>") 'centaur-tabs-forward)
                                        ;(centaur-tabs-mode)
                                        ;(centaur-tabs-headline-match)
                                        ;(setq centaur-tabs-set-modified-marker t
                                        ;      centaur-tabs-modified-marker " ● "
                                        ;      centaur-tabs-cycle-scope 'tabs
                                        ;      centaur-tabs-height 35
                                        ;      centaur-tabs-set-icons t
                                        ;      centaur-tabs-close-button " × ")
                                        ;(dolist (centaur-face '(centaur-tabs-selected
                                        ;                        centaur-tabs-selected-modified
                                        ;                        centaur-tabs-unselected
                                        ;                        centaur-tabs-unselected-modified))
                                        ;  (set-face-attribute centaur-face nil :family "Noto Sans Mono" :height 100))

;; Helm
;;    :PROPERTIES:
;;    :ID:       20210326T232652.855435
;;    :END:
  

       (defun open-local-file-projectile (directory)
         "Helm action function, open projectile file within DIRECTORY
     specify by the keyword projectile-default-file define in
     `dir-locals-file'"
         (let ((default-file (f-join directory (nth 1
                                                     (car (-tree-map (lambda (node)
                                                                       (when (eq (car node) 'projectile-default-file)
                                                                         (format "%s" (cdr node))))
                                                                     (dir-locals-get-class-variables (dir-locals-read-from-dir directory))))))))
           (if (f-exists? default-file)
               (find-file default-file)
             (message "The file %s doesn't exist in the select project" default-file)
             )
           )
         )

   (with-eval-after-load "helm-projectile"
     (helm-add-action-to-source "Open default file"
                                 'open-local-file-projectile
                                 helm-source-projectile-projects)
     )

       ;; (add-to-list 'helm-source-projectile-projects-actions '("Open default file" . open-local-file-projectile) t)


    ;; https://github.com/syl20bnr/spacemacs/issues/13100
    ;(setq completion-styles '(helm-flex))

;; Remove duplicates in helm command history
;;     :PROPERTIES:
;;     :ID:       20210326T232652.860427
;;     :END:
    
;; See: https://github.com/syl20bnr/spacemacs/issues/13564

  (setq history-delete-duplicates t)

;; Scrolling


(good-scroll-mode 1)

;; mu4e (mail)
;;    :PROPERTIES:
;;    :ID:       20210326T232652.868503
;;    :END:
  

     ;; mu4e
     (setq mu4e-maildir "~/Maildir"
           mu4e-attachment-dir "~/downloads"
           mu4e-sent-folder "/Sent"
           mu4e-drafts-folder "/Drafts"
           mu4e-trash-folder "/Trash"
           mu4e-refile-folder "/Archive")

     (setq user-mail-address "neil@doubleloop.net"
           user-full-name  "Neil Mather")

     ;; Get mail
     (setq mu4e-get-mail-command "mbsync protonmail"
           mu4e-change-filenames-when-moving t   ; needed for mbsync
           mu4e-update-interval 120)             ; update every 2 minutes

     (defun htmlize-and-send ()
       "When in an org-mu4e-compose-org-mode message, htmlize and send it."
       (interactive)
       (when (member 'org~mu4e-mime-switch-headers-or-body post-command-hook)
         (org-mime-htmlize)
         (message-send-and-exit)))

     (add-hook 'org-ctrl-c-ctrl-c-hook 'htmlize-and-send t)

     ;; composing mail
                                           ;(setq mu4e-compose-format-flowed nil)
                                           ;(add-hook 'mu4e-compose-mode-hook (lambda () (turn-off-auto-fill) (use-hard-newlines -1)))
     ;; enable format=flowed
     ;; - mu4e sets up visual-line-mode and also fill (M-q) to do the right thing
     ;; - each paragraph is a single long line; at sending, emacs will add the
     ;;   special line continuation characters.
     ;; - also see visual-line-fringe-indicators setting below
     (setq mu4e-compose-format-flowed t)
     ;; because it looks like email clients are basically ignoring format=flowed,
     ;; let's complicate their lives too. send format=flowed with looong lines. :)
     ;; https://www.ietf.org/rfc/rfc2822.txt
     (setq fill-flowed-encode-column 998)
     ;; in mu4e with format=flowed, this gives me feedback where the soft-wraps are
     (setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))

     ;; Send mail
     (setq message-send-mail-function 'smtpmail-send-it
           smtpmail-auth-credentials "~/.authinfo" ;; Here I assume you encrypted the credentials
           smtpmail-smtp-server "127.0.0.1"
           smtpmail-smtp-service 1025)

     ;; look'n'feel
     (setq mu4e-html2text-command 'mu4e-shr2text)
     (setq shr-color-visible-luminance-min 60)
     (setq shr-color-visible-distance-min 5)
     (setq shr-use-colors nil)
     (advice-add #'shr-colorize-region :around (defun shr-no-colourise-region (&rest ignore)))

;; IRC (erc)
;;    :PROPERTIES:
;;    :ID:       20210326T232652.872918
;;    :END:
  

    (setq erc-hide-list '("JOIN" "PART" "QUIT"))

;; Long lines

;;    Fix problem with long lines.  Was mainly giving me grief with Magit - [[id:e73ff9d7-75c3-44b9-9ce5-4396272c0ab5][Magit performance on minified JS and CSS]].


(global-so-long-mode 1)

;; Tidal
;;    :PROPERTIES:
;;    :ID:       20210326T232652.876750
;;    :END:

    ;; tidal
    ;;(add-to-list 'load-path "/home/neil/.emacs.d/private/tidal")
    ;;(require 'tidal)
