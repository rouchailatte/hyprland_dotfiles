;;; init.el --- Minimal fast Emacs config -*- lexical-binding: t -*-

;; Performance
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

;; No backups
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq inhibit-startup-screen t)

;; Package setup
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Install packages on first run
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; Vertico - fast completion UI
(use-package vertico
  :init
  (vertico-mode))

;; Orderless - fuzzy matching
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (orderless-matching-styles '(orderless-flex)))

;; Marginalia - better annotations
(use-package marginalia
  :init
  (marginalia-mode))

;; Consult - powerful search
(use-package consult
  :custom
  (consult-preview-key nil))

;; Projectile - project management
(use-package projectile
  :init
  (projectile-mode +1)
  :custom
  (projectile-enable-caching t)
  (projectile-indexing-method 'alien)
  (projectile-globally-ignored-directories
   '(".git" "node_modules" "__pycache__" "venv" ".venv" "dist" "build"
     "media" "static" "staticfiles"))
  (projectile-globally-ignored-files
   '("TAGS" "*.jpg" "*.png" "*.gif" "*.svg" "*.mp4" "*.pdf" "*.pyc")))

;; Embark - actions
(use-package embark)
(use-package embark-consult)

;; Treemacs - file tree sidebar
(use-package treemacs
  :custom
  (treemacs-width 30)
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode t)
  :config
  ;; Unbind conflicting keys so our navigation keys work
  (define-key treemacs-mode-map (kbd "M-p") nil)
  (define-key treemacs-mode-map (kbd "M-t") nil)
  (define-key treemacs-mode-map (kbd "M-r") nil))

(use-package treemacs-projectile
  :after (treemacs projectile))

;; Imenu-list - function/class outline sidebar
(use-package imenu-list
  :custom
  (imenu-list-focus-after-activation t)
  (imenu-list-auto-resize t)
  :config
  ;; Unbind conflicting keys so our navigation keys work
  (with-eval-after-load 'imenu-list
    (define-key imenu-list-major-mode-map (kbd "M-r") nil)
    (define-key imenu-list-major-mode-map (kbd "M-t") nil)
    (define-key imenu-list-major-mode-map (kbd "M-p") nil)))

;; Helper to get the main code buffer (not sidebar)
(defun my/get-code-buffer ()
  "Return the most recent non-special buffer."
  (let ((buffers (buffer-list)))
    (or (cl-find-if (lambda (buf)
                      (and (not (string-prefix-p " " (buffer-name buf)))
                           (not (string-prefix-p "*" (buffer-name buf)))
                           (not (eq (buffer-local-value 'major-mode buf) 'treemacs-mode))
                           (not (eq (buffer-local-value 'major-mode buf) 'imenu-list-major-mode))))
                    buffers)
        (current-buffer))))

;; Search functions with proper toggle - check minibuffer state directly
(defun my/find-file-in-project ()
  (interactive)
  (if (active-minibuffer-window)
      (abort-recursive-edit)
    (let ((buf (my/get-code-buffer)))
      (when buf (switch-to-buffer buf)))
    (projectile-find-file)))

(defun my/find-imenu ()
  (interactive)
  (if (active-minibuffer-window)
      (abort-recursive-edit)
    (let ((buf (my/get-code-buffer)))
      (when buf (switch-to-buffer buf)))
    (consult-imenu)))

(defun my/find-imenu-multi ()
  (interactive)
  (if (active-minibuffer-window)
      (abort-recursive-edit)
    (let ((buf (my/get-code-buffer)))
      (when buf (switch-to-buffer buf)))
    (consult-imenu-multi)))

(defun my/find-line ()
  (interactive)
  (if (active-minibuffer-window)
      (abort-recursive-edit)
    (let ((buf (my/get-code-buffer)))
      (when buf (switch-to-buffer buf)))
    (consult-line)))

(defun my/find-ripgrep ()
  (interactive)
  (if (active-minibuffer-window)
      (abort-recursive-edit)
    (let ((buf (my/get-code-buffer)))
      (when buf (switch-to-buffer buf)))
    (consult-ripgrep)))

;; Keybindings - bind in both global and minibuffer maps for toggle
(global-set-key (kbd "M-p") 'my/find-file-in-project)
(global-set-key (kbd "M-r") 'my/find-imenu)
(global-set-key (kbd "M-t") 'my/find-imenu-multi)
(global-set-key (kbd "M-f") 'my/find-line)
(global-set-key (kbd "M-F") 'my/find-ripgrep)
(global-set-key (kbd "M-s") 'save-buffer)

;; Sidebar toggles
(global-set-key (kbd "C-c t") 'treemacs)
(global-set-key (kbd "C-c i") 'imenu-list-smart-toggle)

;; Go to line
(global-set-key (kbd "C-g") 'goto-line)

;; Close current buffer
(global-set-key (kbd "M-w") 'kill-this-buffer)

;; Also bind in minibuffer so they work as toggles
(define-key minibuffer-local-map (kbd "M-p") 'my/find-file-in-project)
(define-key minibuffer-local-map (kbd "M-r") 'my/find-imenu)
(define-key minibuffer-local-map (kbd "M-t") 'my/find-imenu-multi)
(define-key minibuffer-local-map (kbd "M-f") 'my/find-line)
(define-key minibuffer-local-map (kbd "M-F") 'my/find-ripgrep)
(define-key minibuffer-local-map (kbd "<escape>") 'abort-recursive-edit)

;; UI - Use default color scheme (light text on dark background)
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)
(show-paren-mode 1)
(setq large-file-warning-threshold nil)
(setq vc-handled-backends nil)

;; Apply default light-on-dark color scheme
(set-face-attribute 'default nil :foreground "white" :background "#300000")
(set-face-attribute 'font-lock-comment-face nil :foreground "red")
(set-face-attribute 'font-lock-string-face nil :foreground "green")
(set-face-attribute 'font-lock-keyword-face nil :foreground "cyan")
(set-face-attribute 'font-lock-function-name-face nil :foreground "blue")
(set-face-attribute 'font-lock-variable-name-face nil :foreground "yellow")
(set-face-attribute 'font-lock-type-face nil :foreground "green")
(set-face-attribute 'minibuffer-prompt nil :foreground "cyan")
(set-face-attribute 'line-number nil :foreground "yellow")
(set-face-attribute 'line-number-current-line nil :foreground "red")

;; Show full file path from project root in mode line
(setq-default mode-line-buffer-identification
              '(:eval (if (buffer-file-name)
                          (let* ((project-root (projectile-project-root))
                                 (file-path (buffer-file-name))
                                 (relative-path (if project-root
                                                    (file-relative-name file-path project-root)
                                                  (file-name-nondirectory file-path))))
                            (propertize relative-path 'face '(:foreground "#00ffff" :weight bold)))
                        (propertize "%b" 'face '(:foreground "#00ffff" :weight bold)))))

;; Python
(setq imenu-auto-rescan t)
(add-hook 'python-mode-hook
          (lambda ()
            (setq imenu-generic-expression
                  '(("Class" "^class \\([a-zA-Z0-9_]+\\)" 1)
                    ("Function" "^def \\([a-zA-Z0-9_]+\\)" 1)
                    ("Model" "^class \\([a-zA-Z0-9_]+\\)(.*Model" 1)
                    ("View" "^class \\([a-zA-Z0-9_]+\\)(.*View" 1)))))

;; Open directory when given as argument
(when (and (> (length command-line-args) 1)
           (file-directory-p (car (last command-line-args))))
  (setq initial-buffer-choice (expand-file-name (car (last command-line-args)))))

;; After startup, open dired if we have a directory
(add-hook 'emacs-startup-hook
          (lambda ()
            (when (and initial-buffer-choice
                       (file-directory-p initial-buffer-choice))
              (dired initial-buffer-choice))
            (setq gc-cons-threshold 800000)))

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
