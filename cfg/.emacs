;; TODO remake C-S-> indent function to accept alt-N as argument with default 4

;; emacs better defaults
;; https://github.com/technomancy/better-defaults

(add-to-list 'load-path "~/emacs")
(add-to-list 'load-path "~/.emacs.d")

;; (load "~/emacs/better-defaults.el")
;; hacked:
(progn
  ;; colorful C-x C-f file select mode
  ;; (ido-mode t)
  (setq ido-enable-flex-matching t)

  (when (fboundp 'tool-bar-mode)
     (tool-bar-mode -1))
  (when (fboundp 'scroll-bar-mode)
     (scroll-bar-mode -1))

  (autoload 'zap-up-to-char "misc"
     "Kill up to, but not including ARGth occurrence of CHAR." t)

  (require 'uniquify)
  (setq uniquify-buffer-name-style 'forward)

  (require 'saveplace)
  (setq-default save-place t)

  (global-set-key (kbd "M-/") 'hippie-expand)
  ;;(global-set-key (kbd "C-x C-b") 'ibuffer)
  (global-set-key (kbd "M-z") 'zap-up-to-char)

  (global-set-key (kbd "C-s") 'isearch-forward-regexp)
  (global-set-key (kbd "C-r") 'isearch-backward-regexp)
  (global-set-key (kbd "C-M-s") 'isearch-forward)
  (global-set-key (kbd "C-M-r") 'isearch-backward)

  (show-paren-mode 1)
  (setq-default indent-tabs-mode nil)
  (setq x-select-enable-clipboard t
        x-select-enable-primary t
        save-interprogram-paste-before-kill t
        apropos-do-all t
        mouse-yank-at-point t
        require-final-newline t
        visible-bell t
        ediff-window-setup-function 'ediff-setup-windows-plain
        save-place-file (concat user-emacs-directory "places")
        backup-directory-alist `(("." . ,(concat user-emacs-directory
                                                 "backups"))))
)


(setq inhibit-startup-message t)

(load "~/emacs/slime")

;; (menu-bar-mode -1)

;; (require 'cl-macs)

;; (defun my-org-confirm-babel-evaluate (lang body)
;;      (not (string= lang "ditaa")))  ; don't ask for ditaa

;; (setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

(add-to-list 'load-path "~/githubs/org-mode/lisp")
(add-to-list 'load-path "~/githubs/org-mode/contrib/lisp" t)

(require 'org)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
;doesn't work, maybe install from git
;(setq org-html-checkbox-type 'html)

(load "~/emacs/undo-tree.el")
(global-undo-tree-mode)

(set-face-attribute 'default nil :height 100)

(setq frame-title-format
  '("emacs - " (buffer-file-name "%f"
    (dired-directory dired-directory "%b"))))

(load "~/emacs/tabbar/tabbar.el")

(tabbar-mode)

;; http://jblevins.org/projects/markdown-mode
(load "~/emacs/markdown-mode.el")

(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; http://www.emacswiki.org/RecentFiles
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 100)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(global-linum-mode 1)



(defun reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (default current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key local-function-key-map
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))

(reverse-input-method "russian-computer")

(global-visual-line-mode t)

;; (global-set-key (kbd "C-S-<iso-lefttab>") 
;;      (lambda () 
;;          (interactive "p")
;;          (indent-code-rigidly 4))
;; )

;; (global-set-key (kbd "C-S-<iso-lefttab>") (kbd "C-u 2 M-x ")) 

(global-set-key (kbd "C->") 
   (lambda (b e &optional n) 
       (interactive "r")
       (indent-code-rigidly b e (or n 4)))
)

(global-set-key (kbd "C-<") 
   (lambda (b e &optional n) 
       (interactive "r")
       (indent-code-rigidly b e (or n (- 0 4))))
)

;autopair

(load-file "~/emacs/autopair.el")
(require 'autopair)
(autopair-global-mode)

;smart indent ny gv (requires autopair)
;http://www.linux.org.ru/forum/general/10710007#comments
 (defun indent-params ()
     (setq-default c-default-style "bsd" c-basic-offset 4))

(add-hook 'c-mode-hook 'indent-params)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; (defun setup-indent ()
;;   (autopair-mode t)
;;   (local-set-key (kbd "RET") 'newline-and-indent))

;; (add-hook 'c-mode-common-hook 'setup-indent)

;; Backup in one directory
;; see http://www.emacswiki.org/emacs/BackupDirectory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; https://web.archive.org/web/20130627154513/http://pymacs.progiciels-bpi.ca/pymacs.html
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-autoload "pymacs")
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path "~/inst/Pymacs"))
;; (setq py-python-command "python3")

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(require 'package-filter)
(require 'jedi)

;; http://tkf.github.io/emacs-jedi/latest/
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
