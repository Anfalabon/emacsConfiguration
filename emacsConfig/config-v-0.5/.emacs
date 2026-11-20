(message ">>> MY EMACS INIT LOADED <<<")
 
;;(setq load-path (cons "~/.emacs.d" load-path))


(desktop-save-mode 1)
(treemacs-project-follow-mode 1)

;; Show IDE-style open file tabs at the top of every window
(global-tab-line-mode 1)



;; Log warnings silently to *Messages* instead of popping open a split window
(setq warning-minimum-level :error)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (with-eval-after-load 'treemacs
;;   (require 'treemacs-nerd-icons)
;;   (treemacs-load-theme "nerd-icons"))

(with-eval-after-load 'tab-line
  ;; 1. Empty bar strip behind the tabs
  (set-face-attribute 'tab-line nil
                      :background "#1e1f22"
                      :foreground "#8c8c8c"
                      :height 1.05
                      :box '(:line-width 2 :color "#1e1f22"))

  ;; 2. Base tab face (prevents white background inheritance!)
  (set-face-attribute 'tab-line-tab nil
                      :background "#1e1f22"
                      :foreground "#9da0a8"
                      :box '(:line-width (8 . 4) :color "#1e1f22"))

  ;; 3. Inactive tabs
  (set-face-attribute 'tab-line-tab-inactive nil
                      :background "#1e1f22"
                      :foreground "#9da0a8"
                      :box '(:line-width (8 . 4) :color "#1e1f22"))

  ;; 4. Active (selected) tab
  (set-face-attribute 'tab-line-tab-current nil
                      :background "#2b2d30"
                      :foreground "#ffffff"
                      :weight 'bold
                      :box '(:line-width (8 . 4) :color "#2b2d30"))

  ;; 5. Tab under mouse hover
  (set-face-attribute 'tab-line-highlight nil
                      :background "#393b40"
                      :foreground "#ffffff"))



;; ;; Only show actual file buffers in the top tab bar (hide *Messages*, *scratch*, etc.)
;; (setq tab-line-tabs-function
;;       (lambda ()
;;         (seq-filter (lambda (buf)
;;                       (and (buffer-file-name buf)
;;                            (not (string-prefix-p "*" (buffer-name buf)))))
;;                     (buffer-list))))





;; Keep tabs in fixed order (never reshuffle on click) and show only real files
;; (defun my-fixed-file-tabs ()
;;   (seq-filter (lambda (buf)
;;                 (and (buffer-file-name buf)
;;                      (not (string-prefix-p "*" (buffer-name buf)))))
;;               (reverse (buffer-list))))

;; (setq tab-line-tabs-function #'my-fixed-file-tabs)



(defvar my-ordered-tab-buffers nil
  "List of file buffers in the exact order they were opened.")

(defun my-stable-file-tabs ()
  "Return open file buffers in fixed creation order without reshuffling."
  ;; 1. Remove any closed/killed buffers from our list
  (setq my-ordered-tab-buffers
        (seq-filter #'buffer-live-p my-ordered-tab-buffers))
  ;; 2. Append any newly opened real files to the end of the list
  (dolist (buf (reverse (buffer-list)))
    (when (and (buffer-file-name buf)
               (not (string-prefix-p "*" (buffer-name buf)))
               (not (memq buf my-ordered-tab-buffers)))
      (setq my-ordered-tab-buffers (append my-ordered-tab-buffers (list buf)))))
  my-ordered-tab-buffers)

(setq tab-line-tabs-function #'my-stable-file-tabs)







;; Ignore internal *...* buffers when switching buffers with C-x b
(setq ido-ignore-buffers '("\\` " "\\*.*\\*"))
(add-to-list 'completion-ignored-extensions "~")

;; Also hide internal buffers in ibuffer (C-x C-b)
(setq ibuffer-never-show-predicates '("\\`\\*.*\\*\\'"))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package ultra-scroll
  :ensure t
  :init
  (setq scroll-conservatively 101
        scroll-margin 0)
  :config
  (ultra-scroll-mode 1))


;; Skip expensive syntax highlighting while actively scrolling fast
(setq fast-but-imprecise-scrolling t)

;; Do not update cursor position/appearance until scrolling stops
(setq redisplay-skip-fontification-on-input t)

;; Disable bidirectional text scanning (huge speed boost for code)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

;; Increase garbage collection threshold so Emacs stops pausing mid-scroll
(setq gc-cons-threshold (* 100 1024 1024)) ;; 100 MB


(setq display-line-numbers-width-start t)



;; ;; Enable native smooth pixel scrolling for mouse wheel and trackpad (Emacs 29+)
;; (when (fboundp 'pixel-scroll-precision-mode)
;;   (pixel-scroll-precision-mode 1)
;;   (setq pixel-scroll-precision-use-momentum t)        ;; Natural trackpad momentum
;;   (setq pixel-scroll-precision-large-scroll-height 40.0))






;; ;; 1. Enable buttery-smooth pixel-by-pixel scrolling (Emacs 29+)
;; (pixel-scroll-precision-mode 1)

;; ;; 2. Stop the jarring half-page jump when cursor reaches screen edge
;; (setq scroll-conservatively 101)
;; (setq scroll-margin 3)

;; ;; 3. Reduce mouse wheel acceleration jumping
;; (setq mouse-wheel-scroll-amount '(2 ((shift) . 1)))
;; (setq mouse-wheel-progressive-speed nil)

;; ;; 4. Fix micro-stutters by raising the Garbage Collection threshold (to 100 MB)
;; (setq gc-cons-threshold (* 100 1024 1024))

;; ;; 5. Speed up reading large outputs from LSP servers / processes
;; (setq read-process-output-max (* 1024 1024))

;; ;; 6. Skip syntax fontification while actively scrolling fast
;; (setq fast-but-imprecise-scrolling t)

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
	      glsl-mode haskell-mode helm-lsp helm-xref j neotree
	      projectile treesit-auto ultra-scroll vterm yasnippet))
 '(warning-suppress-types '((auto-save))))
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


(global-set-key (kbd "M-N") 'scroll-up-command)
(global-set-key (kbd "M-J") 'scroll-down-command)



;;GOTO any line you want
(global-set-key (kbd "C-u") 'goto-line)

;;Set Ctrl+c to copy (kill-ring-save) and Ctrl+y to paste or yank
;;(global-set-key (kbd "C-r") 'kill-ring-save)

;;Opens a file
(global-set-key (kbd "C-o") 'find-file)


(global-set-key (kbd "C-r")  'shell-command)
(global-set-key (kbd "C-q")  'compile)
(global-set-key (kbd "C-:") 'recompile)








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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(defun my/up-5 ()
  (interactive)
  (forward-line -5))

(defun my/down-5 ()
  (interactive)
  (forward-line 5))

(global-set-key (kbd "M-j") #'my/up-5)
(global-set-key (kbd "M-n") #'my/down-5)



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









;; ;; Ensure classic C++ mode uses Allman/BSD style for classes, structs, and functions
;; (setq c-default-style '((java-mode . "java")
;;                         (awk-mode . "awk")
;;                         (other . "bsd")))
;; (setq-default c-basic-offset 4
;;               tab-width 4
;;               indent-tabs-mode nil)

;; ;; Ensure Emacs 29+ Tree-sitter C++ mode also uses BSD/Allman for classes & blocks
;; (setq c-ts-mode-indent-style 'bsd)
;; (setq c-ts-mode-indent-offset 4)

;; ;; Auto-format C/C++ files on save using your ~/.clang-format rules
;; (defun my-cpp-format-setup ()
;;   (add-hook 'before-save-hook 'eglot-format-buffer nil t))

;; (add-hook 'c-mode-hook 'my-cpp-format-setup)
;; (add-hook 'c++-mode-hook 'my-cpp-format-setup)
;; (add-hook 'c-ts-mode-hook 'my-cpp-format-setup)
;; (add-hook 'c++-ts-mode-hook 'my-cpp-format-setup)







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (use-package treesit-auto
;;   :config
;;   (global-treesit-auto-mode))






(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)


;;Ctrl + Left Click to jump to definition
(global-set-key (kbd "<C-down-mouse-1>") 'xref-find-definitions-at-mouse)



;; (use-package eglot
;;   :hook ((c++-mode . eglot-ensure)
;;          (c-mode . eglot-ensure)))


;; (add-hook 'c++-mode-hook
;;           (lambda ()
;;             (add-hook 'before-save-hook
;;                       #'eglot-format-buffer
;;                       nil t)))











;; (require 'corfu)

;; (global-corfu-mode 1)

;; (setq corfu-auto t
;;       corfu-auto-delay 0.1
;;       corfu-auto-prefix 1
;;       corfu-cycle t
;;       corfu-preselect 'prompt)










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
   






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;; Put backup files in ~/.emacs.d/backups/
(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory))))

;; Put auto-save files in ~/.emacs.d/auto-save/
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))



;; Store all backup (file~) and auto-save (#file#) files in one hidden directory
(let ((backup-dir (expand-file-name "backups/" user-emacs-directory))
      (autosave-dir (expand-file-name "autosaves/" user-emacs-directory)))
  (make-directory backup-dir t)
  (make-directory autosave-dir t)
  (setq backup-directory-alist `(("." . ,backup-dir)))
  (setq auto-save-file-name-transforms `((".*" ,autosave-dir t))))

;; Stop creating .#lockfiles in project folders
(setq create-lockfiles nil)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






(add-to-list 'display-buffer-alist
             '("\\*compilation\\*"
               (display-buffer-reuse-window display-buffer-at-bottom)
               (window-height . 0.25))) ;; Takes up 25% of the screen height








;; Save command history across Emacs restarts
(savehist-mode 1)
(add-to-list 'savehist-additional-variables 'compile-command)





;; Kill the current buffer AND close its split window at the same time
;;(global-set-key (kbd "<f9>")  'kill-buffer-and-window)
(global-set-key (kbd "C-c k") 'kill-buffer-and-window)












(defun my-treemacs-custom-background ()
  "Set a distinct background color for the Treemacs side panel."
  (face-remap-add-relative 'default '(:background "#2b2d30"))
  ;; Optional: Also match the empty margin/fringe area on the left edge
  (face-remap-add-relative 'fringe '(:background "#2b2d30")))

(add-hook 'treemacs-mode-hook 'my-treemacs-custom-background)
































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






(with-eval-after-load 'treemacs
  (setq treemacs-width-is-initially-locked nil)
  (setq treemacs-width 30)) ;; Default starting width



;; Enable a clean, draggable vertical divider between panels
(setq window-divider-default-places 'right-only)
(setq window-divider-default-right-width 4) ;; 4px grab area so it is easy to click
(window-divider-mode 1)

;; Style the divider to match your dark CLion theme (#1e1f22)
(set-face-attribute 'window-divider nil :foreground "#1e1f22")
(set-face-attribute 'window-divider-first-pixel nil :foreground "#1e1f22")
(set-face-attribute 'window-divider-last-pixel nil :foreground "#1e1f22")


(global-set-key (kbd "C-M-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-M-<left>")  'shrink-window-horizontally)

