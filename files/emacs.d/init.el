(defun require-package-custom (path git-repo)
  (if (file-exists-p path)
      (progn
	(cl-assert (file-directory-p path))
	(add-to-list 'load-path path))))

(defun nth-or-only (n x)
  (if (consp x) (nth n x) x))

(defun get-and-initialize (packages)
  (mapcar
   (lambda (x) (require-package (nth-or-only 0 x))) packages)
  (mapcar
   (lambda (x) (require (nth-or-only 1 x))) packages))

(defun require-package (package) 
    (setq-default highlight-tabs t)
    "Install given PACKAGE." 
    (unless (package-installed-p package) 
      (unless (assoc package package-archive-contents) 
	(package-refresh-contents)) 
      (package-install package)))

(when (version<= "23" emacs-version)

  ;; I have no idea if that's actually the right version, but it distinguishes the builtin mac emacs (version 22.something)
  
  ;; http://juanjoalvarez.net/es/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/

  ;; packages
  (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/") 
			   ("org" . "http://orgmode.org/elpa/") 
			   ("marmalade" . "http://marmalade-repo.org/packages/") 
			   ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")))
  (package-initialize)

  ; elisp-format (only available as versionless file)
  (get-and-initialize '(cl-lib evil (haskell-mode haskell) recentf tuareg))
  
  (mapcar 
   (lambda (x) 
     (add-to-list 'auto-mode-alist x)) 
   (list '("\\.hs\\'" . haskell-mode) 
	 '("\\.py\\'" . python-mode) 
	 '("\\.js\\'" . js-mode) 
	 '("\\.pl\\'" . perl-mode) 
	 '("\\.ml\\'" . tuareg-mode) 
	 '("\\.nix\\'" . nix-mode) 
	 '("\\.el\\'" . emacs-lisp-mode)))

  
  ;; suspension is annoying and I keep hitting it by mistake
  (global-unset-key (kbd "C-z"))

  (global-unset-key (kbd "M-SPC"))
  (global-unset-key (kbd "M-j"))

  (global-set-key (kbd "M-SPC") 'hippie-expand)
  (global-set-key (kbd "M-j") 'other-window)
  (global-set-key (kbd "C-x e") 'move-end-of-line)

  (when (fboundp 'windmove-default-keybindings) 
    (windmove-default-keybindings))

  (evil-mode +1)
  (recentf-mode 1)
  (setq recentf-max-menu-items 25)
  (global-set-key (kbd "C-x C-r") 'recentf-open-files)

 (custom-set-variables
   ;; custom-set-variables was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(haskell-mode-hook (quote (turn-on-haskell-indent))))
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   )
)
