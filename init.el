
;;--- CUSTOM, CONVENIENCE MACROS AND FUNCTIONS ---------------------------------

;;------------------------------------------------------------------------------
;; rename-modeline - reduce clut in modeline by renaming modeline lighters.
;; (taken from whattheemacsd.com)
;;------------------------------------------------------------------------------
(defmacro rename-modeline (package-name mode new-name)
  `(eval-after-load ,package-name
     '(defadvice ,mode (after rename-modeline activate)
        (setq mode-name ,new-name))))

;;------------------------------------------------------------------------------
;; dired-back-to-top - takes point to first file in a Dired buffer.
;; (taken from whattheemacsd.com)
;;------------------------------------------------------------------------------
(defun dired-back-to-top ()
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 2))

;;------------------------------------------------------------------------------
;; dired-jump-to-bottom - takes point to last file in a Dired buffer.
;; (taken from whattheemacsd.com)
;;------------------------------------------------------------------------------
(defun dired-jump-to-bottom ()
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

;;------------------------------------------------------------------------------
;; move-line-down - moves the current line down 1 line, if possible.
;; (taken from whattheemacsd.com)
;;------------------------------------------------------------------------------
(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (forward-line)
    (transpose-lines 1)
    (forward-line -1)
    (move-to-column col)))

;;------------------------------------------------------------------------------
;; move-line-up - moves the current line up 1 line, if possible.
;; (taken from whattheemacsd.com)
;;------------------------------------------------------------------------------
(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (transpose-lines 1)
    (forward-line -2)
    (move-to-column col)))

;;------------------------------------------------------------------------------
;; open-line-below - create a new line below the current, even in midsentence.
;; (taken from whattheemacsd.com)
;;------------------------------------------------------------------------------
(defun open-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

;;------------------------------------------------------------------------------
;; open-line-above - create a new line above the current, even in midsentence.
;; (taken from whattheemacsd.com)
;;------------------------------------------------------------------------------
(defun open-line-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

;;------------------------------------------------------------------------------
;; magit-status - opens magit status window as the only window in frame.
;; (taken from whattheemacsd.com)
;;------------------------------------------------------------------------------
(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

;;------------------------------------------------------------------------------
;; magit-quit-window - closes the magit status window and restores window
;; configuration.
;; (taken from whattheemacsd.com)
;;------------------------------------------------------------------------------
(defadvice magit-quit-window (around magit-restore-screen activate)
  ad-do-it
  (jump-to-register :magit-fullscreen))

;;------------------------------------------------------------------------------
;; my-layout - setup my initial layout.
;;------------------------------------------------------------------------------
(defun my-layout ()
  (interactive)
  (rename-modeline "python"     python-mode                 "py")
  (rename-modeline "org"        org-agenda-list             "")
  (rename-modeline "org"        org-agenda-day-view         "")
  (rename-modeline "org"        org-agenda-week-view        "")
  (rename-modeline "org"        org-agenda-toggle-time-grid "")
  (rename-modeline "elisp-mode" emacs-lisp-mode             "elisp")
  (delete-other-windows)
  (next-multiframe-window)
  (split-window-vertically)   ;;  -> --
  (enlarge-window 10)
  (split-window-horizontally) ;; -> |
  (dired "~/")
  (next-multiframe-window)
  (dired "~/proj")
  (next-multiframe-window)
  (split-window-horizontally)
  (multi-term)
  (next-multiframe-window)
  (org-agenda-list)
  (org-agenda-day-view)
  (if (eq org-agenda-use-time-grid t)
      (org-agenda-toggle-time-grid))
  (windmove-up))

;;------------------------------------------------------------------------------
;; open-file-from-dired - open file with default viewer from Dired.
;;------------------------------------------------------------------------------
(defun open-file-from-dired ()
  "In dired, open the file named on this line with default viewer."
  (interactive)
  (let* ((file (dired-get-filename nil t)))
    (message "Opening %s..." file)
    (call-process "gvfs-open" nil 0 nil file)
    (message "Opening %s done" file)))

(defun close-term ()
  (interactive)
  (term-send-end)
  (term-send-raw-string "exit")
  (term-send-return)
  (if (> (length (window-list)) 1)
      (delete-window)))


;;--- BASE PACKAGES SETUP ------------------------------------------------------
;;------------------------------------------------------------------------------
;; package - package management platform for Emacs.
;;------------------------------------------------------------------------------
(require 'package)
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;;------------------------------------------------------------------------------
;; use-package - for simplifying your .emacs.
;;------------------------------------------------------------------------------
(eval-when-compile
  (require 'use-package))

;;------------------------------------------------------------------------------
;; powerline - emacs version of the vim powerline.
;;------------------------------------------------------------------------------
(use-package powerline
  :config
  (powerline-default-theme))

;;------------------------------------------------------------------------------
;; visual-fill-column - wraps visual-line-mode buffers at fill-column. 
;;------------------------------------------------------------------------------
(use-package visual-fill-column
  :ensure t
  :init
  (customize-set-variable 'visual-fill-column-width 79)
  (customize-set-variable 'split-window-preferred-function
                          'visual-fill-column-split-window-sensibly)
  (add-hook 'linum-mode-hook
            (lambda()
              (if (eq linum-mode nil)
                  (customize-set-variable 'visual-fill-column-width 84)
                (customize-set-variable 'visual-fill-column-width 79))))
  :config
  (advice-add 'text-scale-adjust :after #'visual-fill-column-adjust))

;;------------------------------------------------------------------------------
;; multi-term - manage multiple terminal buffers.
;;------------------------------------------------------------------------------
(use-package multi-term
  :load-path "~/.emacs.d/multi-term"
  :config
  (setq multi-term-program "/bin/zsh")
  (define-key global-map (kbd "<f9>")
    (lambda ()
      (interactive)
      (split-window-vertically)
      (multi-term)))
  (define-key global-map (kbd "<f8>") 'close-term))

;;------------------------------------------------------------------------------
;; org-bullets - make it nice again.
;;------------------------------------------------------------------------------
(use-package org-bullets
  :defer
  :init
  (add-hook 'org-mode-hook (lambda() (org-bullets-mode 1))))

;;------------------------------------------------------------------------------
;; calfw - a calendar framework for Emacs
;;------------------------------------------------------------------------------
(use-package calfw
  :load-path "~/.emacs.d/calfw")

(use-package calfw-org
  :defer
  :config
  (setq cfw:org-overwrite-default-keybinding t))

;;------------------------------------------------------------------------------
;; org-gcal - org sync with Google Calendar.
;;------------------------------------------------------------------------------
(use-package org-gcal
  :config
  (setq org-gcal-client-id "948419088199-0mshfv7ej48e6jtnakah9dgdaji1mlco.apps.googleusercontent.com"
        org-gcal-client-secret "FNDRJJ2d3ZfJarL5ftOZwis3"
        org-gcal-file-alist '(("cristian.orellana.m@gmail.com" .  "~/.chiri/tasks2.org"))))

;;------------------------------------------------------------------------------
;; engine-mode - minor mode for querying search engines through Emacs. 
;;------------------------------------------------------------------------------
(use-package engine-mode
  :config
  (engine-mode t)
  (engine/set-keymap-prefix (kbd "C-c s"))
  (defengine youtube
    "https://www.youtube.com/results?search_query=%s"
    :keybinding "y")
  (defengine duckduckgo
    "https://duckduckgo.com/?q=%s"
    :keybinding "d")
  (defengine stackoverflow
    "http://stackoverflow.com/search?q=%s"
    :keybinding "s"))


;;------------------------------------------------------------------------------
;; sql-indent
;;------------------------------------------------------------------------------
;;(add-to-list 'load-path "~/.emacs.d/sql-indent")
;;(eval-after-load "sql"
;;  (load-library "sql-indent"))


;;--- PYTHON -------------------------------------------------------------------
;;------------------------------------------------------------------------------
;; python - python's flying circus support for Emacs.
;;------------------------------------------------------------------------------
(use-package python
  :init
  (add-hook 'python-mode-hook
            (lambda () (interactive)
              (linum-mode t)
              (visual-fill-column-mode t))))

(use-package py-autopep8
  :ensure t)

;;------------------------------------------------------------------------------
;; python-django - a Jazzy package for managing Django projects.
;;------------------------------------------------------------------------------
(use-package python-django
  :load-path "~/.emacs.d/python-django"
  :config
  (global-set-key (kbd "C-x j") 'python-django-open-project))

;;------------------------------------------------------------------------------
;; elpy - python IDE
;;------------------------------------------------------------------------------
(use-package elpy
  :ensure t
  :init
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
  (setenv "IPY_TEST_SIMPLE_PROMPT" "1")
  :config
  (elpy-enable)
  :diminish elpy-mode)



;;--- HTML/CSS/JS --------------------------------------------------------------
;;------------------------------------------------------------------------------
;; web-mode - web template editing mode for Emacs.
;;------------------------------------------------------------------------------
(use-package web-mode
  :ensure t
  :init
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.js?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.jsx?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.scss?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.xml?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-hook 'web-mode-hook 'emmet-mode)
  (add-hook 'web-mode-hook
            (lambda()
              (company-mode)
              (electric-indent-local-mode t)
              (local-set-key (kbd "RET")
                             'electric-newline-and-maybe-indent)))
  :config
  (setq web-mode-engines-alist '(("django"    . "\\.html\\'")))
  :bind
  ("M-RET" . open-line-below))


;;------------------------------------------------------------------------------
;; emmet-mode - Emmet support for Emacs.
;;------------------------------------------------------------------------------
(use-package emmet-mode
  :load-path "~/.emacs.d/emmet-mode"
  :config
  (setq emmet-move-cursor-between-quotes t))


;;------------------------------------------------------------------------------
;; web-mode - web template editing mode for Emacs.
;;------------------------------------------------------------------------------
(use-package company-web
  :ensure t
  :init
  (require 'company-web-html)
  (add-to-list 'company-backends 'company-web-html))

;;------------------------------------------------------------------------------
;; flycheck - syntax checking for GNU Emacs
;;------------------------------------------------------------------------------
(use-package flycheck
  :ensure t
  :init
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode)
  :diminish flycheck-mode)

;;------------------------------------------------------------------------------
;; yasnippet - a template system for Emacs.
;;------------------------------------------------------------------------------
(use-package yasnippet
  :ensure t
  :init
  (add-hook 'python-mode-hook 'yas-minor-mode)
  :config
  (yas-reload-all)
  :diminish yas-minor-mode)

;;------------------------------------------------------------------------------
;; whitespace - minor mode to visualize TAB, (HARD) SPACE, NEWLINE.
;;------------------------------------------------------------------------------
(use-package whitespace
  :init
  (customize-set-variable 'whitespace-line '((t (:foreground "red"))))
  (customize-set-variable 'whitespace-line-column 77)
  :bind
  ("C-x w" . whitespace-mode)
  :diminish whitespace-mode)



;; Jekyll-Org
;;(require 'ox-publish)
;;(setq org-publish-project-alist
;;      '(
;;	("org-chirimantecman"
;;	 ;; Path to your org files.
;;	 :base-directory "~/work/blogging/chirimantecman.github.io/_drafts"
;;	 :base-extension "org"
;;	 ;; Path to your Jekyll project.
;;	 :publishing-directory "~/work/blogging/chirimantecman.github.io/_posts"
;;	 :recursive t
;;	 :publishing-function org-html-publish-to-html
;;	 :headline-levels 4 
;;	 :html-extension "html"
;;	 :body-only t ;; Only export section between <body> </body>
;;	 )
;;	("org-static-chiri"
;;	 :base-directory "~/work/blogging/chirimantecman.github.io/_drafts"
;;	 :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php"
;;	 :publishing-directory "~/work/blogging"
;;	 :recursive t
;;	 :publishing-function org-publish-attachment)
;;	("chirimantecman" :components ("org-chirimantecman" "org-static-chiri"))
;;	))








;; PERSONAL FUNCTION DEFINITIONS


;; Open a new org-file prompting for type (template).
;;(defun new-org ()
;;  "Prompts for a type of org file (template) and generates a new buffer."
;;  (interactive)
;;  ( let (( x (read-string "Choose a type - [b] Blog  [g] General  [m] Minute: ")))
;;  (if (not (or (string= x "b") (string= x "g") (string= x "m")))
;;      (message "Invalid choice")
;;    (let ((y (read-string "File name (without extension): ")))
;;      (find-file (concat "~/work/test/" y ".org"))
;;      (insert "#+TITLE:\n")
;;      (insert "#+AUTHOR:Cristian Orellana\n")
;;      (insert "#+INCLUDE:./css/base-blog.org\n")
;;      (beginning-of-buffer)
;;      (end-of-line)))))

;; Toggle dired list switches between -la and -l.
(defun dired-toggle-listing-switches ()
  (interactive)
  (if (string= dired-listing-switches "-l --group-directories-first")
      (setq dired-listing-switches "-lA --group-directories-first")
    (setq dired-listing-switches "-l --group-directories-first"))
  (setq tmp-curr-dir default-directory)
  (kill-buffer)
  (dired tmp-curr-dir)
  )

;; Switch buffer with buffer below this one.
(defun switch-buffer-with-lower ()
  (interactive)
  (setq tb (buffer-name))
  (windmove-down)
  (setq bb (buffer-name))
  (switch-to-buffer tb)
  (windmove-up)
  (switch-to-buffer bb)
  )

;; Switch buffer with buffer above this one.
(defun switch-buffer-with-upper ()
  (interactive)
  (setq bb (buffer-name))
  (windmove-up)
  (setq tb (buffer-name))
  (switch-to-buffer bb)
  (windmove-down)
  (switch-to-buffer tb)
  )

;; Switch buffer with buffer to right of this one.
(defun switch-buffer-with-right ()
  (interactive)
  (setq lb (buffer-name))
  (windmove-right)
  (setq rb (buffer-name))
  (switch-to-buffer lb)
  (windmove-left)
  (switch-to-buffer rb)
  )

;; Switch buffer with buffer to left of this one.
(defun switch-buffer-with-left ()
  (interactive)
  (setq rb (buffer-name))
  (windmove-left)
  (setq lb (buffer-name))
  (switch-to-buffer rb)
  (windmove-right)
  (switch-to-buffer lb)
  )
;;----------------------------------------

;; General Emacs
;; -- Window size.
(global-set-key (kbd "C-{") 'shrink-window-horizontally)
(global-set-key (kbd "C-}") 'enlarge-window-horizontally)
(global-set-key (kbd "C-<dead-acute>") 'shrink-window)
(global-set-key (kbd "C-+") 'enlarge-window)
(define-key global-map (kbd "<f5>")
  (lambda () (interactive) (text-scale-decrease 1)))
(define-key global-map (kbd "<f6>")
  (lambda () (interactive) (text-scale-increase 1)))
;; -- Navigation
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
;; -- Swap buffers (up-down / left-right)
(global-set-key (kbd "C-c <up>") 'switch-buffer-with-upper)
(global-set-key (kbd "C-c <right>") 'switch-buffer-with-right)
(global-set-key (kbd "C-c <down>") 'switch-buffer-with-lower)
(global-set-key (kbd "C-c <left>") 'switch-buffer-with-left)

;; Ido related M-x
(global-set-key
 "\M-x"
 (lambda ()
   (interactive)
   (call-interactively
    (intern
     (ido-completing-read
      "M-x "
      (all-completions "" obarray 'commandp))))))

;; Magit
(global-set-key "\M-gs" 'magit-status)

;; Org Mode
;; -- Agenda.
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-ca" 'org-agenda)
;; -- Links.
(global-set-key "\C-cl" 'org-store-link)
;; -- Capture.
(setq org-default-notes-file "~/.chiri/notes.org")
(global-set-key "\C-cc" 'org-capture)
(setq org-capture-templates
      '(
	("t" "Todo Tasks" entry (file+headline "~/.chiri/tasks2.org" "Tasks")
	 "* %? %^G
%T")
	;;("ft" "Minute FT Task" entry (file+datetree "~/Dropbox/Directorio/Minutas/minutas.org")
	;; "* TODO %t %? %^G")
	;;("fn" "Minute FT Note" entry (file+datetree "~/Dropbox/Directorio/Minutas/minutas.org")
	;; "* %? %^G")
	;;("n" "Quote" entry (file+headline "~/.chiri/notes.org" "Notes")
	;; "* %^{TITLE} %^G
;;#+BEGIN_QUOTE
;;%i
;;#+END_QUOTE
;;%?")
))
(define-key global-map "\C-ct"
  (lambda () (interactive) (org-capture nil "t")))
(define-key global-map "\C-cft"
  (lambda () (interactive) (org-capture nil "ft")))
(define-key global-map "\C-cfn"
  (lambda () (interactive) (org-capture nil "fn")))
(define-key global-map "\C-cn"
  (lambda () (interactive) (org-capture nil "n")))




;; -- Notmuch email linking.
;;(add-to-list 'load-path "/usr/share/org-mode/lisp")
;;(require 'org-notmuch)

;; Dired
(add-hook 'dired-mode-hook
	  '(lambda()
	     (define-key dired-mode-map "\S-v" 'open-file-from-dired)
	     (define-key dired-mode-map "\S-w" 'dired-open-specific-window)
	     (define-key dired-mode-map [backspace]
	       (lambda () (interactive) (find-alternate-file "..")))
	     (define-key dired-mode-map "{" 'dired-toggle-listing-switches)
	     (setq truncate-lines t)))

;; Notmuch package
;;(require 'notmuch)
;;(setq mail-specify-envelope-from t)
;;(setq message-sendmail-envelope-from 'header)
;;(setq mail-envelope-from 'header)
;;(setq message-send-mail-function 'message-send-mail-with-sendmail)
;;(setq sendmail-program "/usr/bin/msmtp")
;;(require 'notmuch-address)
;;(setq notmuch-address-command "~/.mail/notmuch_addresses/notmuch_addresses.py")
;;(notmuch-address-message-insinuate)
;;(add-to-list 'load-path "~/.emacs.d/gnus-alias")
;;(require 'gnus-alias)
;(autoload 'gnus-alias-determine-identity "gnus-alias" "" t)
;(add-hook 'message-setup-hook 'gnus-alias-determine-identity)
;;(setq gnus-alias-identity-alist
;;      '(("home"
;;	 nil ;; Does not refer to any other identity
;;	 "Cristian Orellana M. <cristian.orellana.m@gmail.com>" ;; Sender address
;;	 nil ;; No organization header
;;	 (("Fcc" . "/home/chiri/.mail/sent-gm"))
;;	 nil ;; No extra body text
;;	 nil ;; No signature
;;	 )
;;	("fondateatro"
;;	 nil
;;	 "Cristian Orellana M. <cristian.orellana@fondateatro.cl>"
;;	 "FondaTeatro"
;;	 (("Fcc" . "/home/chiri/.mail/ft/INBOX.Sent"))
;;	 nil
;;	 "~/.mail/.signature.ft"
;;	 )
;;	("zappada"
;;	 nil ;; Does not refer to any other identity
;;	 "Cristian Orellana M. <cristian.orellana@zappada.com>" ;; Sender address
;;	 "Zappada"
;;	 (("Fcc" . "/home/chiri/.mail/sent-zp"))
;;	 nil ;; No extra body text
;;	 nil ;; No signature
;;	 )
;;	))
;; Use "home" identity by default
;;(setq gnus-alias-default-identity "home")
;; Define rules to match work identity
;;(setq gnus-alias-identity-rules)
;;'(("fondateatro" ("any" "cristian.orellana@\\(fondateatro\\.cl\\|help\\.fondateatro.cl\\)" both) "fondateatro"))
;;'(("zappada" ("any" "cristian.orellana@\\(zappada\\.com\\|help\\.zappada.com\\)" both) "zappada"))
;;(gnus-alias-init)
;;(add-hook 'message-mode-hook    ; Change alias.
;;	   '(lambda ()
;;	      (define-key message-mode-map "\C-c\C-s"
;;		'gnus-alias-select-identity)
;;	      (auto-complete-mode)))
;; Binding for new mail.
;;(global-set-key (kbd "C-c m") 'message-mail)

;; Activate general auto-complete.
;;(require 'auto-complete)
;;(add-to-list 'ac-dictionary-directories "/usr/share/auto-complete/dict/")
;;(require 'auto-complete-config)
;;(ac-config-default)


;; Activate key-chord.
;;(require 'key-chord)
;;(key-chord-mode 1)

;; Window navigation
;;(key-chord-define-global "C-M-y" 'engine/search-youtube)
; (key-chord-define-global "ññ" 'windmove-right)
; (key-chord-define-global "mm" 'windmove-down)
; (key-chord-define-global "oo" 'windmove-up)

;; HTML mode customizations.
;(add-hook 'html-mode-hook 'ac-html-enable)
;(add-hook 'html-mode-hook
;	   '(lambda()
;	      (key-chord-define html-mode-map "<<" "\C-c/\n")))

;; C Mode customizations.
;(add-hook 'c-mode-common-hook
;	   '(lambda ()
;	      (require 'auto-complete-c-headers)
;	      (add-to-list 'ac-sources 'ac-source-c-headers)
;	      (add-to-list 'achead:include-directories '"/usr/lib/gcc/x86_64-linux-gnu/4.7/include")
;	      (add-to-list 'achead:include-directories '"/usr/lib/gcc/x86_64-linux-gnu/4.7/include/usr/lib/gcc/x86_64-linux-gnu/4.7/include-fixed")
;	      (add-to-list 'achead:include-directories '"/usr/lib/gcc/x86_64-linux-gnu/4.7/include/usr/include/x86_64-linux-gnu")))
;(add-hook 'c-mode-common-hook
;	   '(lambda ()
;	      (semantic-mode t)
;	      (add-to-list 'ac-sources ac-source-semantic)))


;; CPerl Mode customizations.
;(defalias 'perl-mode 'cperl-mode)
;(add-hook 'cperl-mode-hook    ; perl-completion ac-sources
;	   '(lambda ()
;	      (make-variable-buffer-local 'ac-sources)
;              (setq ac-sources
;		    '(ac-source-perl-completion))))
; (add-hook 'cperl-mode-hook    ; perldoc-at-point
;	   '(lambda ()
;	      (define-key cperl-mode-map "\C-cp"
;		          'perldoc-at-point)))
; (add-hook 'cperl-mode-hook    ; perldoc
;	   '(lambda ()
;	      (define-key cperl-mode-map "\C-c\C-hp"
;		          'perldoc)))
; (add-hook 'cperl-mode-hook    ; perl debugger
;	   '(lambda ()
;	      (define-key cperl-mode-map "\C-c\C-d"
;		          'perldb)))
; (add-hook 'cperl-mode-hook
;           (lambda()
;	     (require 'perl-completion)
;	     (perl-completion-mode t)))

;; Auto-complete java load on demand.
; (defun chiri:init-ac-java ()
; (add-hook 'java-mode-hook 'chiri:init-ac-java)


;;------------------------------------------------------------------------------
;; General config.
;;------------------------------------------------------------------------------

;; Set spaces instead of tabs.
(setq-default indent-tabs-mode nil)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-indent-environment-list
   (quote
    (("verbatim" current-indentation)
     ("verbatim*" current-indentation)
     ("tabular" LaTeX-indent-tabular)
     ("tabular*" LaTeX-indent-tabular)
     ("align" LaTeX-indent-tabular)
     ("align*" LaTeX-indent-tabular)
     ("array" LaTeX-indent-tabular)
     ("eqnarray" LaTeX-indent-tabular)
     ("eqnarray*" LaTeX-indent-tabular)
     ("displaymath")
     ("equation")
     ("equation*")
     ("picture")
     ("tabbing")
     ("table")
     ("table*")
     ("longtable")
     ("longtable*"))))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(backup-directory-alist (quote (("." . "/home/chiri/.chiri/backups"))))
 '(column-number-mode t)
 '(company-idle-delay 0.2)
 '(company-lighter-base "cm")
 '(company-minimum-prefix-length 2)
 '(company-tooltip-idle-delay 0.2)
 '(company-tooltip-limit 20)
 '(compilation-message-face (quote default))
 '(completion-ignored-extensions
   (quote
    (".o" "~" ".bin" ".lbin" ".so" ".a" ".ln" ".blg" ".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".svn/" ".hg/" ".git/" ".bzr/" "CVS/" "_darcs/" "_MTN/" ".fmt" ".tfm" ".class" ".fas" ".lib" ".mem" ".x86f" ".sparcf" ".dfsl" ".pfsl" ".d64fsl" ".p64fsl" ".lx64fsl" ".lx32fsl" ".dx64fsl" ".dx32fsl" ".fx64fsl" ".fx32fsl" ".sx64fsl" ".sx32fsl" ".wx64fsl" ".wx32fsl" ".fasl" ".ufsl" ".fsl" ".dxl" ".lo" ".la" ".gmo" ".mo" ".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps" ".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo" ".log" ".tex~")))
 '(delete-by-moving-to-trash t)
 '(delete-old-versions t)
 '(dired-dwim-target t)
 '(dired-listing-switches "-l --group-directories-first")
 '(display-time-24hr-format t)
 '(display-time-day-and-date nil)
 '(display-time-mode t)
 '(doc-view-continuous t)
 '(electric-pair-mode t)
 '(electric-pair-pairs (quote ((123 . 125) (40 . 41) (34 . 34))))
 '(elpy-modules
   (quote
    (elpy-module-company elpy-module-eldoc elpy-module-yasnippet elpy-module-django)))
 '(elpy-rpc-backend "jedi")
 '(elpy-rpc-python-command "python")
 '(fci-always-use-textual-rule nil)
 '(fci-rule-character-color "red")
 '(fci-rule-color "red")
 '(fci-rule-column 70)
 '(flycheck-display-errors-delay 0.3)
 '(flycheck-highlighting-mode (quote symbols))
 '(flycheck-indication-mode (quote left-fringe))
 '(font-use-system-font nil)
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(global-company-mode t)
 '(gnus-alias-identity-alist
   (quote
    (("home" nil "Cristian Orellana M. <cristian.orellana.m@gmail.com>" nil
      (("Fcc" . "/home/chiri/.mail/sent-gm"))
      nil nil)
     ("fondateatro" nil "Cristian Orellana M. <cristian.orellana@fondateatro.cl>" "FondaTeatro"
      (("Fcc" . "/home/chiri/.mail/ft/INBOX.Sent"))
      nil "~/.mail/.signature.ft")
     ("zappada" nil "Cristian Orellana M. <cristian.orellana@zappada.com>" "Zappada"
      (("Fcc" . "/home/chiri/.mail/zp/INBOX.Sent"))
      nil nil))))
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-tail-colors
   (quote
    (("#49483E" . 0)
     ("#67930F" . 20)
     ("#349B8D" . 30)
     ("#21889B" . 50)
     ("#968B26" . 60)
     ("#A45E0A" . 70)
     ("#A41F99" . 85)
     ("#49483E" . 100))))
 '(ido-enable-flex-matching t)
 '(ido-everywhere t)
 '(ido-mode t nil (ido))
 '(inhibit-startup-screen t)
 '(kept-new-versions 6)
 '(mail-citation-hook nil)
 '(menu-bar-mode nil)
 '(message-cite-function (quote message-cite-original))
 '(message-cite-reply-position (quote below))
 '(message-cite-style (quote message-cite-style-gmail))
 '(message-default-mail-headers "Fcc: /home/chiri/.mail/sent-gm")
 '(message-forward-before-signature nil)
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(org-agenda-files (quote ("~/.chiri/tasks2.org")))
 '(org-agenda-include-diary t)
 '(org-agenda-window-setup (quote current-window))
 '(org-bullets-bullet-list (quote (" " " " " " " ")))
 '(org-clock-into-drawer "LOGBOOK")
 '(org-hide-leading-stars nil)
 '(org-indent-indentation-per-level 2)
 '(org-log-done (quote note))
 '(org-log-into-drawer t)
 '(org-log-note-headings
   (quote
    ((done . "NOTE:")
     (state . "State %-12s from %-12S %t")
     (note . "Note taken on %t")
     (reschedule . "Rescheduled from %S on %t")
     (delschedule . "Not scheduled, was %S on %t")
     (redeadline . "New deadline from %S on %t")
     (deldeadline . "Removed deadline, was %S on %t")
     (refile . "Refiled on %t")
     (clock-out . ""))))
 '(org-pretty-entities t)
 '(org-return-follows-link t)
 '(org-src-fontify-natively t)
 '(org-src-tab-acts-natively t)
 '(org-startup-indented t)
 '(package-selected-packages
   (quote
    (emmet-mode skewer-mode company-web-html company-web web-mode material-theme use-package org-gcal engine-mode org-bullets magit powerline)))
 '(python-shell-interpreter "python")
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(split-window-preferred-function (quote visual-fill-column-split-window-sensibly))
 '(term-bind-key-alist
   (quote
    (("C-c C-c" . term-interrupt-subjob)
     ("C-c C-e" . term-send-esc)
     ("C-p" . previous-line)
     ("C-n" . next-line)
     ("C-s" . isearch-forward)
     ("C-r" . isearch-backward)
     ("C-m" . term-send-return)
     ("C-y" . term-paste)
     ("M-f" . term-send-forward-word)
     ("M-b" . term-send-backward-word)
     ("M-o" . term-send-backspace)
     ("M-p" . term-send-up)
     ("M-n" . term-send-down)
     ("M-M" . term-send-forward-kill-word)
     ("M-N" . term-send-backward-kill-word)
     ("<C-backspace>" . term-send-backward-kill-word)
     ("M-r" . term-send-reverse-search-history)
     ("M-d" . term-send-delete-word)
     ("M-," . term-send-raw)
     ("M-." . comint-dynamic-complete))))
 '(tool-bar-mode nil)
 '(tramp-default-method "ssh")
 '(truncate-lines nil)
 '(truncate-partial-width-windows nil)
 '(use-package-verbose t)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(version-control t)
 '(visual-fill-column-fringes-outside-margins nil)
 '(visual-fill-column-width 79)
 '(web-mode-auto-close-style 2)
 '(web-mode-markup-indent-offset 2)
 '(weechat-color-list
   (quote
    (unspecified "#272822" "#49483E" "#A20C41" "#F92672" "#67930F" "#A6E22E" "#968B26" "#E6DB74" "#21889B" "#66D9EF" "#A41F99" "#FD5FF0" "#349B8D" "#A1EFE4" "#F8F8F2" "#F8F8F0")))
 '(whitespace-line (quote ((t (:foreground "red")))) t)
 '(whitespace-line-column 79 t)
 '(window-min-height 1))

(put 'narrow-to-region 'disabled nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#3F3F3F" :foreground "#DCDCCC" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "PfEd" :family "Inconsolata"))))
 '(whitespace-empty ((t (:background "dark gray"))))
 '(whitespace-hspace ((t (:background "#4F4F4F" :foreground "gainsboro"))))
 '(whitespace-indentation ((t (:background "#3F3F3F" :foreground "#F0DFAF"))))
 '(whitespace-line ((t (:background "#3F3F3F" :foreground "orange red"))))
 '(whitespace-newline ((t (:foreground "dark gray"))))
 '(whitespace-space ((t (:background "#3F3F3F" :foreground "gainsboro"))))
 '(whitespace-trailing ((t (:background "#3F3F3F" :foreground "yellow")))))
(put 'dired-find-alternate-file 'disabled nil)


;;--- SETUP --------------------------------------------------------------------
;; Theme and layout.
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(add-hook 'after-init-hook (lambda () (load-theme 'zenburn t)))
(my-layout)

;; Setup linum-mode
(setq linum-format "%4d ")
(global-set-key (kbd "<f7>") 'linum-mode)

;; Keybindings for custom macros and functions.
;; Collapse next line onto current.
(global-set-key (kbd "M-DEL")
                (lambda ()
                  (interactive)
                  (join-line -1)))
(global-set-key (kbd "<M-S-down>") 'move-line-down)
(global-set-key (kbd "<M-S-up>") 'move-line-up)
(global-set-key (kbd "<C-return>") 'open-line-below)
(global-set-key (kbd "<C-S-return>") 'open-line-above)
(define-key dired-mode-map
  (vector 'remap 'beginning-of-buffer) 'dired-back-to-top)
(define-key dired-mode-map
  (vector 'remap 'end-of-buffer) 'dired-jump-to-bottom)

;; Activate company-mode everywhere.
(add-hook 'after-init-hook 'global-company-mode)
