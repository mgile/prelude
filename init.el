;;; init.el --- Prelude's configuration entry point.
;;
;; Copyright (c) 2011 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar@batsov.com>
;; URL: http://batsov.com/prelude
;; Version: 1.0.0
;; Keywords: convenience
;;
;; Modified Feb-2013 
;; Copyright (c) 2013 Michael Gile
;;


;; This file is not part of GNU Emacs.

;;; Commentary:

;; This file simply sets up the default load path and requires
;; the various modules defined within Emacs Prelude.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(global-linum-mode 1)

(require 'package)
(package-initialize)

(message "Prelude is powering up... Be patient, Master %s!" (getenv "USER"))

(defvar prelude-dir (file-name-directory load-file-name)
  "The root dir of the Emacs Prelude distribution.")
(defvar prelude-core-dir (expand-file-name "core" prelude-dir)
  "The home of Prelude's core functionality.")
(defvar prelude-modules-dir (expand-file-name  "modules" prelude-dir)
  "This directory houses all of the built-in Prelude modules.")
(defvar prelude-personal-dir (expand-file-name "personal" prelude-dir)
  "Users of Emacs Prelude are encouraged to keep their personal configuration
changes in this directory. All Emacs Lisp files there are loaded automatically
by Prelude.")
(defvar prelude-vendor-dir (expand-file-name "vendor" prelude-dir)
  "This directory house Emacs Lisp packages that are not yet available in
ELPA (or MELPA).")
(defvar prelude-snippets-dir (expand-file-name "snippets" prelude-dir)
  "This folder houses additional yasnippet bundles distributed with Prelude.")
(defvar prelude-personal-snippets-dir (expand-file-name "snippets" prelude-personal-dir)
  "This folder houses additional yasnippet bundles added by the users.")
(defvar prelude-savefile-dir (expand-file-name "savefile" prelude-dir)
  "This folder stores all the automatically generated save/history-files.")
(defvar prelude-modules-file (expand-file-name "prelude-modules.el" prelude-dir)
  "This files contains a list of modules that will be loaded by Prelude.")

(unless (file-exists-p prelude-savefile-dir)
  (make-directory prelude-savefile-dir))

(defun prelude-add-subfolders-to-load-path (parent-dir)
 "Adds all first level `parent-dir' subdirs to the
Emacs load path."
 (dolist (f (directory-files parent-dir))
   (let ((name (expand-file-name f parent-dir)))
     (when (and (file-directory-p name)
     (not (equal f ".."))
     (not (equal f ".")))
       (add-to-list 'load-path name)))))

;; add Prelude's directories to Emacs's `load-path'
(add-to-list 'load-path prelude-core-dir)
(add-to-list 'load-path prelude-modules-dir)
(add-to-list 'load-path prelude-vendor-dir)
(prelude-add-subfolders-to-load-path prelude-vendor-dir)

(require 'dash)

;; add Prelude's directories to Emacs's `load-path'
(add-to-list 'load-path prelude-modules-dir)
(add-to-list 'load-path prelude-vendor-dir)

;; the core stuff
(require 'prelude-packages)
(require 'prelude-ui)
(require 'prelude-core)
(require 'prelude-mode)
(require 'prelude-editor)
(require 'prelude-global-keybindings)

;; OSX specific settings
(when (eq system-type 'darwin)
  (require 'prelude-osx))

(setq-default default-directory "~/dev")

;; config changes made through the customize UI will be store here
(setq custom-file (expand-file-name "custom.el" prelude-personal-dir))

;; load the personal settings (this includes `custom-file')
(when (file-exists-p prelude-personal-dir)
  (mapc 'load (directory-files prelude-personal-dir 't "^[^#].*el$")))

(require 'jabber)
(setq jabber-account-list
      '(("mgile@symplified.com"
         (:network-server . "talk.google.com")
         (:connection-type . ssl))))

(blink-cursor-mode 1)

(setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
                                      global-semanticdb-minor-mode
                                      global-semantic-idle-summary-mode
                                      global-semantic-decoration-mode
                                      global-semantic-highlight-func-mode
                                      global-semantic-stickyfunc-mode
                                      global-semantic-mru-bookmark-mode))
(setq semantic-load-turn-everything-on t)
(semantic-mode 1)

(require 'semantic)
(require 'semantic/wisent)
(require 'semantic/wisent/java-tags)
(require 'semantic/ia)
(require 'semantic/senator)
(require 'semantic/sb)
;(global-ede-mode 1)                    ;; enable project management
(require 'semantic/bovine/gcc)                ;; use gcc headers
(require 'semantic/java)               ;; and java too

;; Malabar
(add-to-list 'load-path (expand-file-name "~/.emacs.d/vendor/malabar/lisp"))
(require 'malabar-mode)
(setq malabar-groovy-lib-dir "/Users/mgile/.emacs.d/vendor/malabar/lib")
(add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))
(setq malabar-extra-source-locations '("/Users/mgile/dev/wayin/wayinserver/wayin_backend/src/main/java"))

;(add-to-list 'load-path (expand-file-name "~/.emacs.d/vendor/jdee/lisp"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/vendor/elib"))
;(setq jde-web-browser "chrome")

;; Use the full Java 1.5 grammer to parse Java
;(autoload 'wisent-java-default-setup "wisent" "Hook run to setup Semantic in 'java-mode'." nil nil)

;(setq jde-auto-parse-enable nil)
;(setq jde-enable-senator nil)
;(load "jde-autoload")

;; load jde-testng
;(require 'jde-testng)


;; jdibug
(setq jdibug-connect-hosts (quote ("localhost:8000"))
      jdibug-run-jvm-args (quote ("-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=y"))
      jdibug-use-jde-source-paths nil
      jdibug-source-paths
      (list
       "/Users/mgile/dev/wayin/wayinserver/wayin_backend/src/main/java"
       "/usr/lib/jvm/java-6-sun/src"
       )
)
(setq jdibug-refresh-delay 0.01)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/vendor/jdibug"))
(require 'jdibug)

(defun my-jdibug-mode-hook ()
  ;; IDEA style debug short cuts
  (define-key c-mode-base-map [ (M-f8) ] 'jdibug-step-into)
  (define-key c-mode-base-map [ (f8) ] 'jdibug-step-over)
  (define-key c-mode-base-map [ (f9) ] 'jdibug-step-out)
  (define-key c-mode-base-map [ (M-f7) ] 'jdibug-resume)
  (define-key c-mode-base-map [ (M-f5) ] 'jdibug-resume-all)
  (define-key c-mode-base-map [ (f10) ] 'jdibug-toggle-breakpoint)
  (global-set-key "\C-\M-b" 'jdibug-connect)
  (global-set-key "\C-\M-d" 'jdibug-disconnect)
)
(add-hook 'c-mode-common-hook 'my-jdibug-mode-hook)
(add-hook 'jdibug-connected-hook 'jdibug-resume-all)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make Emacs understand Ant's and Maven's output
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'compile)
(setq compilation-error-regexp-alist
  (append (list
           ;; works for jikes
           '("^\\s-*\\[[^]]*\\]\\s-*\\(.+\\):\\([0-9]+\\):\\([0-9]+\\):[0-9]+:[0-9]+:" 1 2 3)
           ;; works for javac
           '("^\\s-*\\[[^]]*\\]\\s-*\\(.+\\):\\([0-9]+\\):" 1 2)
           ;; works for maven 2.x
           '("^\\(.*\\):\\[\\([0-9]*\\),\\([0-9]*\\)\\]" 1 2 3)
           ;; works for maven 3.x
           '("^\\(\\[ERROR\\] \\)?\\(/[^:]+\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\]" 2 3 4)
           '("^\\(\\[WARNING\\] \\)?\\(/[^:]+\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\]" 2 3 4)
           )
          compilation-error-regexp-alist))

(require 'twittering-mode)
(add-hook 'twittering-mode-hook
           (lambda ()
             (mapc (lambda (pair)
                     (let ((key (car pair))
                           (func (cdr pair)))
                       (define-key twittering-mode-map
                         (read-kbd-macro key) func)))
                   '(("F" . twittering-friends-timeline)
                     ("R" . twittering-replies-timeline)
                     ("U" . twittering-user-timeline)
                     ("W" . twittering-update-status-interactive)))))

(setq twittering-icon-mode t)                ; Show icons
(setq twittering-timer-interval 300)         ; Update your timeline each 300 seconds (5 minutes)
(setq twittering-url-show-status nil)        ; Keeps the echo area from showing all the http processes

;;; SmartTabs
(require 'smarttabs)

(setq-default tab-width 4) ; or any other preferred value
    (setq cua-auto-tabify-rectangles nil)
    (defadvice align (around smart-tabs activate)
      (let ((indent-tabs-mode nil)) ad-do-it))
    (defadvice align-regexp (around smart-tabs activate)
      (let ((indent-tabs-mode nil)) ad-do-it))
    (defadvice indent-relative (around smart-tabs activate)
      (let ((indent-tabs-mode nil)) ad-do-it))
    (defadvice indent-according-to-mode (around smart-tabs activate)
      (let ((indent-tabs-mode indent-tabs-mode))
        (if (memq indent-line-function
                  '(indent-relative
                    indent-relative-maybe))
            (setq indent-tabs-mode nil))
        ad-do-it))
    (defmacro smart-tabs-advice (function offset)
      `(progn
         (defvaralias ',offset 'tab-width)
         (defadvice ,function (around smart-tabs activate)
           (cond
            (indent-tabs-mode
             (save-excursion
               (beginning-of-line)
               (while (looking-at "\t*\\( +\\)\t+")
                 (replace-match "" nil nil nil 1)))
             (setq tab-width tab-width)
             (let ((tab-width fill-column)
                   (,offset fill-column)
                   (wstart (window-start)))
               (unwind-protect
                   (progn ad-do-it)
                 (set-window-start (selected-window) wstart))))
            (t
             ad-do-it)))))
    (smart-tabs-advice c-indent-line c-basic-offset)
    (smart-tabs-advice c-indent-region c-basic-offset)


;;; nXhtml
(load "/Users/mgile/.emacs.d/vendor/nxhtml/autostart.el")

(message "Prelude is ready to do thy bidding, Master %s!" (getenv "USER"))

(prelude-eval-after-init
 ;; greet the use with some useful tip
 (run-at-time 5 nil 'prelude-tip-of-the-day))

;;; init.el ends here
