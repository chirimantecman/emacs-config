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
 '(org-use-sub-superscripts (quote {}))
 '(package-selected-packages
   (quote
    (emmet-mode skewer-mode company-web-html company-web web-mode material-theme use-package org-gcal engine-mode org-bullets magit powerline)))
 '(python-shell-interpreter "python")
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
 '(web-mode-auto-close-style 1)
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
 '(default ((t (:inherit nil :stipple nil :background "#3F3F3F" :foreground "#DCDCCC" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "ADBO" :family "Source Code Variable"))))
 '(whitespace-empty ((t (:background "dark gray"))))
 '(whitespace-hspace ((t (:background "#4F4F4F" :foreground "gainsboro"))))
 '(whitespace-indentation ((t (:background "#3F3F3F" :foreground "#F0DFAF"))))
 '(whitespace-line ((t (:background "#3F3F3F" :foreground "orange
 red"))))
 '(whitespace-newline ((t (:foreground "dark gray"))))
 '(whitespace-space ((t (:background "#3F3F3F" :foreground "gainsboro"))))
 '(whitespace-trailing ((t (:background "#3F3F3F" :foreground "yellow")))))
(put 'dired-find-alternate-file 'disabled nil)


