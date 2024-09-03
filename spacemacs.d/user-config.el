;; Preamble

;; This is the [[id:b69228c3-14fe-41f9-bfdb-e5e34d7c2a9b][literate configuration]] source for my [[id:b529d37d-becd-495d-be37-dd91a4dc039b][spacemacs]] user config.  I use [[id:d0cfbb57-33fe-4715-932f-a34128c3f782][org-babel]] to tangle it together into the actual config file.


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; GENERATED FROM USER-CONFIG.ORG - DON'T EDIT THIS DIRECTLY!
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Set up keyboard shortcuts for PHPUnit

  (with-eval-after-load 'php-mode
    (define-key php-mode-map (kbd "C-c C-t t") 'phpunit-current-test)
    (define-key php-mode-map (kbd "C-c C-t c") 'phpunit-current-class)
    (define-key php-mode-map (kbd "C-c C-t p") 'phpunit-current-project))

;; Use web-mode for Laravel templates.
;;     :PROPERTIES:
;;     :ID:       20210326T232652.758318
;;     :mtime:    20220611203431 20211127120059
;;     :ctime:    20211127120059
;;     :END:

  (add-to-list 'auto-mode-alist '("\\.blade.php\\'" . web-mode))

;; Completion
;;   :PROPERTIES:
;;   :mtime:    20211127120059
;;   :ctime:    20211127120059
;;   :END:

;; Ignoring completion case mainly for org-roam - hope it doesn't muss with other stuff.


(setq completion-ignore-case t)

;; Use org-super-agenda a nicer looking agenda.
;;      :PROPERTIES:
;;      :ID:       20210326T232652.763253
;;      :mtime:    20211127120059
;;      :ctime:    20211127120059
;;      :END:

  (org-super-agenda-mode)
  (setq org-agenda-custom-commands
        '(("g" "Super groups"
           agenda ""
           ((org-super-agenda-groups
             '((:auto-property "agenda-group")))))
          ("u" "Super view"
           ((org-super-agenda-groups
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

;; org-timeline
;;      :PROPERTIES:
;;      :ID:       20210326T232652.790249
;;      :mtime:    20220713110622 20220705221026
;;      :ctime:    20220705221026
;;      :END:

;; For getting a visual representation of a day plan. https://github.com/Fuco1/org-timeline


     (require 'org-timeline)
     (add-hook 'org-agenda-finalize-hook 'org-timeline-insert-timeline :append)

;; org-schedule-effort

;; See [[id:6c5d48ed-db88-4892-91cb-81e7ad698cea][Calculating effort estimates and scheduled times in org-mode]].


(defun org-schedule-effort ()
(interactive)
  (save-excursion
    (org-back-to-heading t)
    (let* (
        (element (org-element-at-point))
        (effort (org-element-property :EFFORT element))
        (scheduled (org-element-property :scheduled element))
        (ts-year-start (org-element-property :year-start scheduled))
        (ts-month-start (org-element-property :month-start scheduled))
        (ts-day-start (org-element-property :day-start scheduled))
        (ts-hour-start (org-element-property :hour-start scheduled))
        (ts-minute-start (org-element-property :minute-start scheduled)) )
      (org-schedule nil (concat
        (format "%s" ts-year-start)
        "-"
        (if (< ts-month-start 10)
          (concat "0" (format "%s" ts-month-start))
          (format "%s" ts-month-start))
        "-"
        (if (< ts-day-start 10)
          (concat "0" (format "%s" ts-day-start))
          (format "%s" ts-day-start))
        " "
        (if (< ts-hour-start 10)
          (concat "0" (format "%s" ts-hour-start))
          (format "%s" ts-hour-start))
        ":"
        (if (< ts-minute-start 10)
          (concat "0" (format "%s" ts-minute-start))
          (format "%s" ts-minute-start))
        "+"
        effort)) )))

;; capture templates
;;      :PROPERTIES:
;;      :ID:       20210326T232652.768075
;;      :mtime:    20211127120059
;;      :ctime:    20211127120059
;;      :END:

   (require 'org-protocol)
   ;(add-to-list 'load-path "/home/neil/.emacs.d/private/org-protocol-capture-html")
   ;(require 'org-protocol-capture-html)

   (setq org-capture-templates
         (quote
          (("c" "TODO scheduled today"
            entry (file+headline "~/Documents/org/Tasks.org" "Inbox")
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
;;     :mtime:    20211127120059
;;     :ctime:    20211127120059
;;     :END:
   

   (setq org-refile-targets '((nil :maxlevel . 9)
                              (org-agenda-files :maxlevel . 9)))
   (setq org-outline-path-complete-in-steps nil)         ; Refile in a single go
   (setq org-refile-use-outline-path t)                  ; Show full paths for refiling

   (setq org-agenda-files (list
        "~/Documents/org/Tasks.org"))

;; Babel
;;     :PROPERTIES:
;;     :ID:       20210326T232652.776075
;;     :mtime:    20230430140620 20211127120059
;;     :ctime:    20211127120059
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
;;      :mtime:    20230719160925 20221016204501 20211127120059
;;      :ctime:    20211127120059
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

;; Extracting bolder sections from a block of text into a bullet list


(defun ngm/extract-bolded-sections ()
  "Extract bolded sections from the selected region and place them after it in a bullet list."
  (interactive)
  (if (region-active-p)
      (let ((bolded-sections '())
            (case-fold-search nil)
            (region-start (region-beginning))
            (region-end (region-end)))
        (goto-char region-start)
        (while (re-search-forward "\\*\\([^*]+\\)\\*" region-end t)
          (push (match-string 1) bolded-sections))
        (setq bolded-sections (reverse bolded-sections))
        (goto-char region-end)
        (newline)
        (insert "- ")
        (insert (mapconcat 'identity bolded-sections "\n- "))
        (newline))
    (message "No region selected.")))

;; Writing and knowledge management
;;   :PROPERTIES:
;;   :ID:       20210326T232652.794077
;;   :mtime:    20230819120725 20230813231035 20230813210816 20230719155745 20230702145926 20230512140501 20230512123451 20221221180402
;;   :ctime:    20221221180402
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

;; word counts

;; Needs the org-wc package.


(require 'org-wc)
(spacemacs/declare-prefix "o" "own-menu")
(spacemacs/set-leader-keys "ow" 'org-wc-display nil)
(spacemacs/set-leader-keys "oc" 'org-cite-insert nil)

;; citations

;; Handy links:

;; - https://kristofferbalintona.me/posts/202206141852/
;; - https://blog.tecosaur.com/tmio/2021-07-31-citations.html#working-with-zotero


(require 'citeproc)
(require 'oc-csl)
(require 'oc-biblatex)
(setq org-cite-export-processors
'((latex csl)
(t csl)))

(setq org-cite-csl-styles-dir
 (expand-file-name "~/Nextcloud2/Zotero/styles/"))

;; Setup


(setq org-roam-directory "/home/neil/commonplace")
(setq org-roam-dailies-directory "journal")

;; Load my helper files
;; :PROPERTIES:
;; :mtime:    20230505154822
;; :ctime:    20230505154822
;; :END:


(load "~/.emacs.d/private/commonplace-lib/commonplace-lib.el")

;; Customise the slug function
;;     :PROPERTIES:
;;     :mtime:    20211127120059
;;     :ctime:    20211127120059
;;     :END:


(with-eval-after-load 'org-roam
  (cl-defmethod org-roam-node-slug ((node org-roam-node))
    (let ((title (org-roam-node-title node)))
      (commonplace/slugify-title title)))
  )

;; Linking to other files
;;     :PROPERTIES:
;;     :mtime:    20230813205704 20211127120059
;;     :ctime:    20211127120059
;;     :END:

;;     Because I use export heavily, I'm kind of dependent on file-based links right now (as far as I understand).  This is going to be problematic when org-roam v2 rolls around, but cross that bridge when we come to it.


(setq org-roam-prefer-id-links t)

;; Prefer immediate DB update method.
;;     :PROPERTIES:
;;     :ID:       20210326T232652.802602
;;     :mtime:    20230813192518 20230719144519 20211127120059
;;     :ctime:    20211127120059
;;     :END:

;; This updates the DB on save, rather than on an idle timer.  I was finding idle timer frustrating, as the unexpected DB update interrupted my flow.  Updating on save works better for me, as I tend to pause momentarily after a save anyway, as I usually save at the end of a sentence.

(org-roam-db-autosync-enable)

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
;;     :mtime:    20211127120059
;;     :ctime:    20211127120059
;;     :END:

;;     Add CREATED and LAST_MODIFIED properties to the new note.

  (setq org-roam-capture-templates
   '(("d" "default" plain "%?"
      :if-new (file+head "${slug}.org"
"#+TITLE: ${title}
#+CREATED: %u
#+LAST_MODIFIED: %U

")
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
;;     :mtime:    20211127120059
;;     :ctime:    20211127120059
;;     :END:

;;     I would prefer to do this on org-roam files only.
;;     See  [[https://org-roam.discourse.group/t/update-a-field-last-modified-at-save/321/19][Update a field (#+LAST_MODIFIED: ) at save - How To - Org-roam]].
;;     Doesn't seem to work though.

  (setq time-stamp-active t
        time-stamp-start "#\\+LAST_MODIFIED:[ \t]*"
        time-stamp-end "$"
        time-stamp-format "\[%Y-%02m-%02d %3a %02H:%02M\]")
  (add-hook 'before-save-hook 'time-stamp nil)



;; Using the org-roam-timestamps package.


(add-hook 'org-mode-hook (org-roam-timestamps-mode))

;; Graph settings
;;     :PROPERTIES:
;;     :ID:       20210326T232652.824834
;;     :mtime:    20211127120059
;;     :ctime:    20211127120059
;;     :END:

;; Exclude some of the big files from the graph.

  (setq org-roam-graph-exclude-matcher '("sitemap" "index" "recentchanges"))

;; org-roam-ui
;;     :PROPERTIES:
;;     :ID:       20210326T232652.829175
;;     :mtime:    20220803203705
;;     :ctime:    20220803203705
;;     :END:

;;     Requires v2.  Used to be org-roam-server.


;(require 'websocket)
;(add-to-list 'load-path "~/.emacs.d/private/org-roam-ui")
;(load-library "org-roam-ui")
;(use-package websocket
;              :after org-roam)

;(use-package org-roam-ui
;              :after org-roam ;; or :after org
;              :hook (org-roam . org-roam-ui-mode)
;              :config
;              )

;; org-roam-bibtex


(setq org-cite-global-bibliography '("~/commonplace/My Library.bib"))

;; Misc

;; See: https://org-roam.discourse.group/t/possible-to-ignore-directories-within-the-org-directory/2454/


(setq org-roam-file-exclude-regexp
      (concat "^" (expand-file-name org-roam-directory) "/tempdir/"))

;; Themes
;;    :PROPERTIES:
;;    :ID:       20210326T232652.841598
;;    :END:

    (doom-themes-treemacs-config)
    (doom-themes-org-config)

;; Solaire
;;    :PROPERTIES:
;;    :ID:       20210326T232652.845889
;;    :mtime:    20211127120059
;;    :ctime:    20211127120059
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
;;    :mtime:    20211127120059
;;    :ctime:    20211127120059
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
;;    :mtime:    20211127120059
;;    :ctime:    20211127120059
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
;;    :mtime:    20211127120059
;;    :ctime:    20211127120059
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

;; cook-mode


(load "~/.emacs.d/private/cook-mode/cook-mode.el")

;; TODO Need to review this, I think it'll be resolved more elegantly upstream at some point.
(with-eval-after-load 'undo-tree
  (setq undo-tree-auto-save-history nil))
