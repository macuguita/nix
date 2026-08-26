(setq custom-file "~/.config/emacs/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;; Package stuff
(require 'package)

(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Emacs poops
(make-directory "~/.cache/emacs/backups/" t)
(make-directory "~/.cache/emacs/auto-save/" t)

(setq backup-directory-alist '(("." . "~/.cache/emacs/backups/")))
(setq auto-save-file-name-transforms '((".*" "~/.cache/emacs/auto-save/" t)))
(setq create-lockfiles nil)
(setq delete-old-versions t)
(setq kept-new-versions 6)
(setq kept-old-versions 2)
(setq version-control t)

;; UI
(set-face-attribute 'default nil
                     :family "Maple Mono NL NF"
                     :height 140)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(setq inhibit-startup-screen t)
(setq initial-buffer-choice t)
(setq-default display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-nord t)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

;;; Modes
;; Nix
(use-package nix-ts-mode
  :ensure t
  :mode "\\.nix\\'")
(add-hook 'nix-ts-mode-hook
          (lambda ()
            (setq-local tab-width 2)
            (setq-local nix-indent-offset 2)))
;; C
(use-package c-ts-mode
  :ensure nil
  :mode (("\\.c\\'" . c-ts-mode)
         ("\\.h\\'" . c-ts-mode)))
;; Rust
(use-package rust-ts-mode
  :ensure t
  :mode "\\.rs\\'")
;; NBT
(use-package nbt-mode
  :vc (:url "https://tangled.org/macuguita.com/nbt-mode.el"
            :rev :newest))
;; Typescript
(use-package typescript-ts-mode
  :ensure t
  :mode ("\\.ts\\'" "\\.mts\\'"))

;; Keybinds
(cua-mode 1) ;; Copy paste mode
(setq select-enable-clipboard t)

;; macOS: Command = Ctrl, Option = Meta.
;; Right Option stays untouched so dead keys/accented chars still work.
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'control
        mac-option-modifier 'meta
        mac-right-option-modifier 'none))

(defun macuguita/duplicate-line-or-region ()
  "Duplicate region if active, else duplicate the current line."
  (interactive)
  (if (use-region-p)
      (let ((text (buffer-substring (region-beginning) (region-end))))
        (goto-char (region-end))
        (insert text))
    (let ((col (current-column))
          (text (buffer-substring (line-beginning-position) (line-end-position))))
      (end-of-line)
      (newline)
      (insert text)
      (move-to-column col))))

(global-set-key (kbd "C-d") #'macuguita/duplicate-line-or-region)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)


(auto-save-visited-mode 1)
(setq auto-save-visited-interval 5)

(require 'whitespace)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq-default show-trailing-whitespace t)

(setq whitespace-style '(face trailing))
(add-hook 'prog-mode-hook 'whitespace-mode)

(defun macuguita/fontify-leading-whitespace (limit)
  (while (re-search-forward "^[ \t]+" limit t)
    (let ((beg (match-beginning 0))
          (end (match-end 0))
          (color (or (face-foreground 'font-lock-comment-face nil t) "gray30")))
      (save-excursion
        (goto-char beg)
        (while (< (point) end)
          (let* ((c (char-after))
                 (repl (if (eq c ?\t)
                           (propertize "»\t" 'face `(:foreground ,color))
                         (propertize "·" 'face `(:foreground ,color)))))
            (put-text-property (point) (1+ (point)) 'display repl))
          (forward-char 1)))))
  nil)

(defun macuguita/leading-whitespace-setup ()
  (add-to-list 'font-lock-extra-managed-props 'display)
  (font-lock-add-keywords nil '((macuguita/fontify-leading-whitespace)))
  (font-lock-flush))

(add-hook 'prog-mode-hook #'macuguita/leading-whitespace-setup)

(use-package ido
  :init
  (ido-mode 1)
  :config
  (setq ido-everywhere t)
  (setq ido-enable-flex-matching t)
  (setq ido-ignore-files '("\\`#" "\\`.#" "\\`\\.\\." "\\`\\.")))

;; Ido for M-x
(use-package smex
  :ensure t
  :bind (("M-x" . smex)
         ("M-X" . smex-major-mode-commands))
  :config
  (smex-initialize))

(use-package vterm
  :ensure t
  :bind (("C-c t" . vterm))
  :hook (vterm-mode . (lambda () (setq show-trailing-whitespace nil)))
  :config
  (setq vterm-max-scrollback 10000)
  (setq vterm-kill-buffer-on-exit t)

  (add-hook 'vterm-exit-functions
            (lambda (buffer event)
              (let ((window (get-buffer-window buffer)))
                (when (window-live-p window)
                  (delete-window window)))))

  (add-to-list 'display-buffer-alist
               '("\\*vterm\\*"
                 (display-buffer-at-bottom)
                 (window-height . 0.3))))

;; Jump to def stuff
(remove-hook 'xref-backend-functions #'etags--xref-backend)

(use-package dumb-jump
  :ensure t
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate t))

(use-package eglot
  :config

  (defun macuguita/eglot-ensure ()
    (condition-case nil
        (let ((inhibit-message t))
          (eglot-ensure))
      (error nil)))

  (add-hook 'prog-mode-hook #'macuguita/eglot-ensure)

  (add-to-list 'eglot-server-programs
               '(nix-mode . ("nixd")))

  (setq eglot-ignored-server-capabilities
        '(:hoverProvider                    ;; No hover documentation
          :signatureHelpProvider            ;; No function signature popups
          :documentHighlightProvider        ;; No highlighting symbols under cursor
          :documentFormattingProvider       ;; No auto-formatting
          :documentOnTypeFormattingProvider ;; No formatting while typing
          :inlayHintProvider))              ;; No inline type hints

  (add-hook 'eglot-managed-mode-hook (lambda () (flymake-mode -1))))

(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c C-r") #'eglot-rename))

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  :init
  (global-corfu-mode))

(global-set-key (kbd "<C-down-mouse-1>") 'ignore)
(global-set-key (kbd "<C-mouse-1>") #'xref-find-definitions-at-mouse)

(global-set-key (kbd "<C-down-mouse-3>") 'ignore)
(global-set-key (kbd "<C-mouse-3>") #'xref-go-back)

(use-package envrc
  :ensure t
  :config
  (envrc-global-mode))

(defun macuguita/dired-mouse-click (event)
  "In Dired, move to the clicked line and open the file/folder normally."
  (interactive "e")
  (mouse-set-point event)
  (dired-find-file))

(use-package dired
  :ensure nil
  :bind (("C-x C-d" . dired-jump)
         :map dired-mode-map
         ("<mouse-1>" . macuguita/dired-mouse-click)
         ("<mouse-2>" . macuguita/dired-mouse-click))
  :config
  (setq dired-kill-when-opening-new-dired-buffer t)
  (setq dired-listing-switches "-alh --group-directories-first"))
