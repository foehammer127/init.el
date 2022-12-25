;; No Startup Message
(setq inhibit-startup-message t
	  cursor-type 'barC)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-hl-line-mode t)
(line-number-mode t)

;; No More Alarms
(setq ring-bell-function 'ignore)

;; Package Stuff

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives
	     '("org" . "http://orgmode.org/elpa/") t)


(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure 't)



(if (display-graphic-p)
    (progn

      ;; Remove UI
      (menu-bar-mode -1)
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      )
  )




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("512ce140ea9c1521ccaceaa0e73e2487e2d3826cc9d287275550b47c04072bc4" "7a424478cb77a96af2c0f50cfb4e2a88647b3ccca225f8c650ed45b7f50d9525" "6945dadc749ac5cbd47012cad836f92aea9ebec9f504d32fe89a956260773ca4" "02f57ef0a20b7f61adce51445b68b2a7e832648ce2e7efb19d217b6454c1b644" default))
 '(package-selected-packages
   '(zig-mode general cider clojure-mode haskell-mode magit rust-mode vterm lsp-mode go-mode dashboard-hackernews dashboard hydra evil-collection evil helpful ivy-rich counsel ivy which-key doom-themes all-the-icons doom-modeline auto-package-update use-package))
 '(warning-suppress-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; General Config

(setq-default tab-width 4)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq select-enable-primary t
	  select-enable-clipboard t)
(use-package doom-modeline)
(doom-modeline-mode 1)
(use-package all-the-icons)

(use-package projectile)

(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5
        which-key-idle-secondary-delay 0.5)
  (which-key-setup-side-window-bottom))

(use-package swiper)
(use-package ivy
  :bind(("C-s" . swiper)
	:map ivy-minibuffer-map
	("TAB" . ivy-alt-done

	 )
	("C-l" . ivy-alt-done)
	("C-j" . ivy-next-line)
	("C-k" . ivy-previous-line)
	:map ivy-switch-buffer-map
	("C-k" . ivy-previous-line)
	("C-l" . ivy-done)
	("C-d" . ivy-switch-buffer-kill)
	:map ivy-reverse-i-search-map
	("C-k" . ivy-previous-line)
	("C-d" . ivy-reverse-i-search-kill)))
(ivy-mode 1)

(use-package counsel
  :bind(("M-x" . counsel-M-x)
	("C-x b" . counsel-ibuffer)
	("C-x C-f" . counsel-find-file)
	:map minibuffer-local-map
	("C-r" . 'counsel-minibuffer-history)))

(set-face-attribute 'default nil :height 150)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(use-package doom-themes)
(load-theme 'doom-challenger-deep)

(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook
		shell-mode-hook
		vterm-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-function-function #'helpful-callable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package ivy-rich)
(ivy-rich-mode 1)

(use-package general
  :config
  (general-create-definer foe/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (foe/leader-keys
	"t" '(:ignore t :which-key "toggles")
	"o" '(:ignore o :which-key "open")
	"l" '(:ignore l :which-key "clojure bindings")
   "tt" '(counsel-load-theme :which-key "choose theme")))


(foe/leader-keys
  "e" '(vterm :which-key "open vterm")
  "k" '(ido-kill-buffer :which-key "kill-buffer")
  "j" '(counsel-switch-buffer :which-key "switch-buffer"))

(defun foe/evil-hook ()
  (dolist (mode '(custom-mode
		  eshell-mode
		  git-rebase-mode
		  erc-mode
		  circe-server-mode
		  circe-chat-mode
		  circe-query-mode
		  sauron-mode
		  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :hook (evil-mode . foe/evil-hook)
  :config
  
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "K" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))




(evil-mode 1)


(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package hydra)

(use-package dashboard
  :after (all-the-icons) 
  :init
  (dashboard-setup-startup-hook)
  :custom
  (dashboard-banner-logo-title "Wassup Bro")
  (dashboard-startup-banner 'logo)
  (dashboard-center-content t)
  (dashboard-set-navigator t)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-items '((projects . 5)
                     (recents . 5))))


(use-package lsp-mode)

;; Language Specific Modes
(use-package go-mode)
(use-package rust-mode)
(use-package vterm)
(use-package haskell-mode)
(use-package zig-mode)


;; Clojure Specific Stuff
(use-package clojure-mode)
(use-package cider)
(foe/leader-keys
  "ll" '(cider-jack-in :which-key "Open new Live Repl of Clojure Project")
 )

;; Magit (Git Client)
(use-package magit
	:bind
	("C-x g" . magit-status))
