(message ">>> MY EMACS INIT LOADED <<<")
 
;;(setq load-path (cons "~/.emacs.d" load-path))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(set-face-attribute 'default nil
                    :font "Monospace"
                    :height 115)

;;Source Code Pro 13
;;Monospace-12






(use-package vterm
  :ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3"
    "DeepSkyBlue" "gray50"])
 '(custom-enabled-themes '(deeper-blue))
 '(ispell-dictionary nil)
 '(package-selected-packages
   '(apheleia auto-complete clang-format company corfu dap-mode flycheck
	      glsl-mode helm-lsp helm-xref neotree projectile
	      treesit-auto vterm yasnippet)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "gray13"))))
 '(font-lock-keyword-face ((t (:foreground "mediumpurple"))))
 '(font-lock-type-face ((t (:foreground "deep sky blue"))))
 '(font-lock-variable-name-face ((t (:foreground "sea green")))))






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(require 'package)


(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(menu-bar-mode -1)
(tool-bar-mode -1)

;;(global-tab-line-mode 1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)

(setq inhibit-startup-screen t)

(add-hook 'window-setup-hook 'toggle-frame-maximized t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;(load-theme 'solarized-dark t)
;;(load-theme 'modus-vivendi t)
;;(load-theme 'sanityinc-solarized-dark t)   
   




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (use-package treesit-auto
;;   :config
;;   (global-treesit-auto-mode))






;; (use-package eglot
;;   :hook ((c++-mode . eglot-ensure)
;;          (c-mode . eglot-ensure)))


;; (add-hook 'c++-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook
;;                       #'eglot-format-buffer
;;                       nil t)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;















;;Close the current file
(global-set-key (kbd "C-x k") 'kill-buffer)
;;kill the current buffer
(global-set-key (kbd "C-w") #'kill-current-buffer) 


;;Map Ctrl+to move to the beginning and Ctrl+j to move to the end of line
(global-set-key (kbd "C-h") 'move-beginning-of-line)
(global-set-key (kbd "C-i") 'move-end-of-line)

(global-set-key (kbd "C-j") 'previous-line);;we can also use C-p 
(global-set-key (kbd "C-k") 'backward-char);;we can also use C-b
;;(global-set-key (kdb "C-f") 'forward-char) ;;we can also use C-f(same)
(global-set-key (kbd "C-n") 'next-line)    ;;we can also use C-n(same)

(global-set-key (kbd "C-e") 'forward-word)
(global-set-key (kbd "C-l") 'backward-word)


(global-set-key (kbd "M-n") 'scroll-up-command)
(global-set-key (kbd "M-j") 'scroll-down-command)



;;goto any line you want
(global-set-key (kbd "C-u") 'goto-line)

;;Set Ctrl+c to copy (kill-ring-save) and Ctrl+y to paste or yank
;;(global-set-key (kbd "C-r") 'kill-ring-save)

;;Opens a file
(global-set-key (kbd "C-o") 'find-file)







;;stops the cursor from blinking
(blink-cursor-mode 0)


(setq-default cursor-type 'bar)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;; (defun move-line-up ()
;;   (interactive)
;;   (transpose-lines 1)
;;   (forward-line -2))

;; (defun move-line-down ()
;;   (interactive)
;;   (forward-line 1)
;;   (transpose-lines 1)
;;   (forward-line -1))










(defun move-region (start end n)
  "Move the selected region N lines."
  (let ((region (delete-and-extract-region start end)))
    (forward-line n)
    (let ((new-start (point)))
      (insert region)
      (set-mark new-start)
      (goto-char (+ new-start (length region)))
      (setq deactivate-mark nil))))

(defun move-text-up ()
  (interactive)
  (if (use-region-p)
      (move-region (region-beginning) (region-end) -1)
    (transpose-lines 1)
    (forward-line -2)))

(defun move-text-down ()
  (interactive)
  (if (use-region-p)
      (move-region (region-beginning) (region-end) 1)
    (forward-line 1)
    (transpose-lines 1)
    (forward-line -1)))



(global-set-key (kbd "M-<up>") #'move-text-up)
(global-set-key (kbd "M-<down>") #'move-text-down)



;;switch between the buffers

(global-set-key (kbd "<C-tab>") #'next-buffer)
(global-set-key (kbd "<C-S-iso-lefttab>") #'previous-buffer)



;; (pixel-scroll-precision-mode 1)
;; (set-cursor-color "#ff6600")      ; any color name or hex



(defun my/up-10 ()
  (interactive)
  (forward-line -10))

(defun my/down-10 ()
  (interactive)
  (forward-line 10))

(global-set-key (kbd "M-J") #'my/up-10)
(global-set-key (kbd "M-N") #'my/down-10)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








(use-package treemacs
  :ensure t
  :bind
  ("C-c t" . treemacs))






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

















(add-hook 'c++-ts-mode-hook
          (lambda ()
            (setq c-ts-mode-indent-offset 4)
            (setq tab-width 4)
            (setq indent-tabs-mode nil)))



(setq-local c-ts-mode-indent-offset 4)



(setq c-default-style "linux"
      c-basic-offset 4)

(electric-pair-mode 1)



























;; (use-package corfu
;;   :ensure t
;;   :init
;;   (global-corfu-mode)

;;   :custom
;;   (corfu-auto t)          ;; Show completion automatically
;;   (corfu-auto-delay 0.1)  ;; Delay before popup
;;   (corfu-auto-prefix 2)   ;; Start after typing 2 characters
;;   (corfu-cycle t))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;(use-package apheleia
;;;;  :ensure t
;;;;  :config
;;;;  (apheleia-global-mode +1))

;; Auto-save buffers after 1 second of idle time
;;;;(setq auto-save-visited-interval 1)
;;;;(auto-save-visited-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






(global-set-key (kbd "C-t") (kbd "M-! urxvt RET"))
   
