(message ">>> MY EMACS INIT LOADED <<<")
 
;;(setq load-path (cons "~/.emacs.d" load-path))


(desktop-save-mode 1)


;; Show IDE-style open file tabs at the top of every window
(global-tab-line-mode 1)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Never visually wrap long lines—scroll horizontally instead (like CLion)
(setq-default truncate-lines t)

;; Pan horizontally 1 column at a time instead of jumping
(setq hscroll-step 1)
(setq hscroll-margin 5)


;; Show horizontal scrollbar at the bottom of windows (like CLion)
(horizontal-scroll-bar-mode 1)


;; Prevent Emacs from ever inserting automatic line breaks while typing
(auto-fill-mode -1)
(remove-hook 'text-mode-hook #'turn-on-auto-fill)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;; ;; Log warnings silently to *Messages* instead of popping open a split window
;; (setq warning-minimum-level :error)
;; ;; Prevent native-comp / byte-compile warnings from opening *Compile-Log*
;; (setq native-comp-async-report-warnings-errors 'silent)
;; ;; Use clangd/eglot instead of legacy make check-syntax
;; (remove-hook 'flymake-diagnostic-functions 'flymake-cc)

;; ;; Skip fontifying newly revealed text during rapid scrolling
;; (setq fast-but-imprecise-scrolling t)

;; ;; Defer fontification slightly while actively scrolling/typing
;; (setq jit-lock-defer-time 0.1)







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






;; ;; 1. Force Emacs to use our dark gray tooltip instead of GTK's light system tooltip
;; (setq x-gtk-use-system-tooltips nil)
;; (tooltip-mode 1)
;; (setq tooltip-delay 0.15)
;; (set-face-attribute 'tooltip nil
;;                     :background "#2b2d30"
;;                     :foreground "#dfe1e5"
;;                     :box '(:line-width 1 :color "#43454a")
;;                     :height 0.95)

;; ;; 2. Helper to color tab filenames by Git status (Green = Added, Blue = Modified, White = Clean)
;; (defun my-clion-tab-git-color (file)
;;   "Return CLion-style Git status text color for FILE."
;;   (let ((state (and file (vc-state file))))
;;     (pcase state
;;       ('added    "#6aab73")   ;; Green (like TestDeque.cpp & DynamicArray.hpp)
;;       ('edited   "#548af7")   ;; Blue (like container/CMakeLists.txt)
;;       ('conflict "#fa6675")   ;; Red
;;       (_         "#dfe1e5")))) ;; Clean off-white (like testGL.cpp & stringfwd.h)

;; ;; 3. Render CLion-style file icon + unique parent/filename + Git status color
;; (defun my-clion-tab-name (buffer &optional _buffers)
;;   "Render tab label with file-type Nerd Icon, disambiguated name, and Git color."
;;   (let* ((file (buffer-file-name buffer))
;;          (raw-name (buffer-name buffer))
;;          ;; Show parentFolder/CMakeLists.txt when multiple files share a name (like CMakeLists.txt)
;;          (display-name
;;           (if (and file (string-equal (file-name-nondirectory file) "CMakeLists.txt"))
;;               (concat (file-name-nondirectory
;;                        (directory-file-name (file-name-directory file)))
;;                       "/" raw-name)
;;             raw-name))
;;          (icon (if (and file (fboundp 'nerd-icons-icon-for-file))
;;                    (concat (nerd-icons-icon-for-file file :height 0.92 :v-adjust 0.0) " ")
;;                  ""))
;;          (color (my-clion-tab-git-color file)))
;;     (concat icon (propertize display-name 'face `(:foreground ,color)))))

;; (setq tab-line-tab-name-function #'my-clion-tab-name)

;; ;; 4. Preserve clickable '×' button & show full path in the dark gray tooltip
;; (defun my-clion-tab-format (tab tabs)
;;   "Format TAB with native close button and full-path hover tooltip."
;;   (let* ((formatted (copy-sequence (tab-line-tab-name-format-default tab tabs)))
;;          (buf (if (bufferp tab) tab (cdr (assq 'buffer tab))))
;;          (file (and (bufferp buf) (buffer-file-name buf)))
;;          (path (if file (abbreviate-file-name file) (buffer-name buf))))
;;     (add-text-properties 0 (length formatted) (list 'help-echo path) formatted)
;;     formatted))

;; (setq tab-line-tab-name-format-function #'my-clion-tab-format)
;; (setq tab-line-close-tab-function #'kill-buffer)
;; (setq tab-line-close-button-show 'selected)














































;; Enable file-type icons on tabs
(use-package nerd-icons
  :ensure t)

;; Keep tabs in fixed creation order (never reshuffle on click)
(defvar my-ordered-tab-buffers nil
  "List of file buffers in the exact order they were opened.")

(defun my-stable-file-tabs ()
  "Return open file buffers in fixed creation order without reshuffling."
  (setq my-ordered-tab-buffers
        (seq-filter #'buffer-live-p my-ordered-tab-buffers))
  (dolist (buf (reverse (buffer-list)))
    (when (and (buffer-file-name buf)
               (not (string-prefix-p "*" (buffer-name buf)))
               (not (memq buf my-ordered-tab-buffers)))
      (setq my-ordered-tab-buffers (append my-ordered-tab-buffers (list buf)))))
  my-ordered-tab-buffers)

(setq tab-line-tabs-function #'my-stable-file-tabs)

;; Show '×' close button on tabs (like CLion)
(setq tab-line-close-button-show t)





;; 1. Keep tab text clean with Nerd Icon + filename
(defun my-clion-tab-name (buffer &optional _buffers)
  "Render tab label with Nerd Icon and buffer name."
  (let* ((file (buffer-file-name buffer))
         (name (buffer-name buffer))
         (icon (if (and file (fboundp 'nerd-icons-icon-for-file))
                   (concat (nerd-icons-icon-for-file file :height 0.9 :v-adjust 0.0) " ")
                 "")))
    (concat icon name)))

(setq tab-line-tab-name-function #'my-clion-tab-name)

;; 2. Preserve clickable '×' close button AND show full file path on hover
(defun my-clion-tab-format (tab tabs)
  "Format TAB with native close button click action and full-path tooltip."
  (let* ((formatted (tab-line-tab-name-format-default tab tabs))
         (buf (if (bufferp tab) tab (cdr (assq 'buffer tab))))
         (file (and (bufferp buf) (buffer-file-name buf)))
         (path (if file (abbreviate-file-name file) (buffer-name buf))))
    (propertize formatted 'help-echo path)))

(setq tab-line-tab-name-format-function #'my-clion-tab-format)






;; Make clicking the '×' button actually close/kill the buffer instead of just burying it
(setq tab-line-close-tab-function #'kill-buffer)

;; ;; 3. Show '×' close button only on the currently selected tab (like CLion)
;; (setq tab-line-close-button-show 'selected)







;; Enable mouse hover tooltips so hovering a tab shows the full file path popup
(tooltip-mode 1)
(setq tooltip-delay 0.2)
(set-face-attribute 'tooltip nil
                    :background "#2b2d30"
                    :foreground "#dfe1e5"
                    :height 0.95)






;; CLion New UI Tab Colors & Blue Active Underline
(with-eval-after-load 'tab-line
  ;; Empty bar strip behind tabs
  (set-face-attribute 'tab-line nil
                      :background "#1e1f22"
                      :foreground "#8c8c8c"
                      :height 1.05
                      :box nil)

  ;; Base tab face
  (set-face-attribute 'tab-line-tab nil
                      :background "#1e1f22"
                      :foreground "#dfe1e5"
                      :box '(:line-width (8 . 5) :color "#1e1f22"))

  ;; Inactive tabs
  (set-face-attribute 'tab-line-tab-inactive nil
                      :background "#1e1f22"
                      :foreground "#dfe1e5"
                      :box '(:line-width (8 . 5) :color "#1e1f22"))

  ;; Active tab with CLion's signature blue bottom underline (#3574f0)
  (set-face-attribute 'tab-line-tab-current nil
                      :background "#2b2d30"
                      :foreground "#ffffff"
                      :weight 'bold
                      :underline '(:color "#3574f0" :position t)
                      :box '(:line-width (8 . 5) :color "#2b2d30"))

  ;; Modified (unsaved) file tab text in CLion blue (#548af7)
  (set-face-attribute 'tab-line-tab-modified nil
                      :foreground "#548af7")

  ;; Tab hover highlight
  (set-face-attribute 'tab-line-highlight nil
                      :background "#2b2d30"
                      :foreground "#ffffff"))








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
   '(apheleia auto-complete clang-format company corfu
              corfu-candidate-overlay corfu-prescient dap-mode
              flycheck glsl-mode haskell-mode helm-lsp helm-xref j
              neotree projectile treesit-auto ultra-scroll vterm
              yasnippet))
 '(warning-suppress-types '((auto-save))))



;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:background "#212121"))))
;;  '(font-lock-keyword-face ((t (:foreground "#3A7BBB"))))
;;  '(font-lock-type-face ((t (:foreground "#3A7BBB"))))
;;  '(font-lock-variable-name-face ((t (:foreground "sea green")))))




;; ;; Highlight the name after class, struct, enum, or union in #AF5887
;; (defface my-cpp-class-name-face
;;   '((t (:foreground "#AF5887")))
;;   "Face for names following class, struct, enum, or union.")

;; (dolist (mode '(c-mode c++-mode c-ts-mode c++-ts-mode))
;;   (font-lock-add-keywords
;;    mode
;;    '(("\\_<\\(?:class\\|struct\\|union\\|enum\\(?:[[:space:]]+class\\|[[:space:]]+struct\\)?\\)[[:space:]]+\\([A-Za-z_][A-Za-z0-9_]*\\)"
;;       1 'my-cpp-class-name-face prepend))))






;; Make custom types/classes (like Alpha) #AF5887 everywhere,
;; while keeping primitive keywords (void, int, char, unsigned) #3A7BBB
(custom-set-faces
 '(default ((t (:background "#212121"))))
 '(font-lock-keyword-face ((t (:foreground "#3A7BBB"))))
 '(font-lock-type-face ((t (:foreground "#AF5887"))))
 '(font-lock-variable-name-face ((t (:foreground "#FFFFFF"))))
 '(font-lock-function-name-face ((t (:foreground "#F5D356"))))
 '(font-lock-function-call-face ((t (:foreground "E5C07B")))))


(set-face-attribute 'font-lock-constant-face nil :foreground "#3A7BBB")




;; 2. Custom face for class/struct/enum/union names in #AF5887
(defface my-cpp-class-name-face
  '((t (:foreground "#AF5887")))
  "Face for names following class, struct, enum, or union.")

;; 3. Color ONLY the identifier after class/struct/enum/union (using 'keep' so comments stay untouched)
(dolist (mode '(c-mode c++-mode c-ts-mode c++-ts-mode))
  (font-lock-add-keywords
   mode
   '(("\\_<\\(?:class\\|struct\\|union\\|enum\\(?:[[:space:]]+class\\|[[:space:]]+struct\\)?\\)[[:space:]]+\\([A-Za-z_][A-Za-z0-9_]*\\)"
      1 'my-cpp-class-name-face keep))))




;; 1. Enable maximum syntax highlighting detail (Level 4 = CLion-level coloring)
(setq treesit-font-lock-level 4)

;; 2. Automatically use Tree-sitter modes (c-ts-mode, c++-ts-mode) & install grammars
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))






















;; (use-package vterm
;;   :ensure t)
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(ansi-color-faces-vector
;;    [default default default italic underline success warning error])
;;  '(ansi-color-names-vector
;;    ["black" "red3" "ForestGreen" "yellow3" "blue" "magenta3"
;;     "DeepSkyBlue" "gray50"])
;;  '(custom-enabled-themes '(deeper-blue))
;;  '(ispell-dictionary nil)
;;  '(package-selected-packages
;;    '(apheleia auto-complete clang-format company corfu
;;               corfu-candidate-overlay corfu-prescient dap-mode
;;               flycheck glsl-mode haskell-mode helm-lsp helm-xref j
;;               neotree projectile treesit-auto ultra-scroll vterm
;;               yasnippet))
;;  '(warning-suppress-types '((auto-save))))


;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:background "gray13"))))
;;  '(font-lock-keyword-face ((t (:foreground "#3A7BBB"))))
;;  '(font-lock-type-face ((t (:foreground "#3A7BBB"))))
;;  '(font-lock-variable-name-face ((t (:foreground "sea green")))))








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
(scroll-bar-mode 1)

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

(define-key input-decode-map [?\C-i] [C-i])
(global-set-key (kbd "<C-i>") 'move-end-of-line)

(global-set-key (kbd "C-j") 'previous-line);;we can also use C-p 
(global-set-key (kbd "C-k") 'backward-char);;we can also use C-b
;;(global-set-key (kdb "C-f") 'forward-char) ;;we can also use C-f(same)
(global-set-key (kbd "C-n") 'next-line)    ;;we can also use C-n(same)

(global-set-key (kbd "C-e") 'forward-word)
(global-set-key (kbd "C-l") 'backward-word)


(global-set-key (kbd "M-N") 'scroll-up-command)
(global-set-key (kbd "M-J") 'scroll-down-command)



;;GOTO any line you want
(global-set-key (kbd "C-x u") 'goto-line)
(global-set-key (kbd "C-u") 'undo)



;; Bind C-s to save the current file
(global-set-key (kbd "C-s") 'save-buffer)
;; Bind C-x s to incremental search forward
(global-set-key (kbd "C-x C-s") 'isearch-forward)



;;Set Ctrl+c to copy (kill-ring-save) and Ctrl+y to paste or yank
;;(global-set-key (kbd "C-r") 'kill-ring-save)

;;Opens a file
(global-set-key (kbd "C-o") 'find-file)


(global-set-key (kbd "C-r")  'shell-command)
(global-set-key (kbd "C-q")  'compile)
(global-set-key (kbd "C-:") 'recompile)


;;Use TAB for both smart indentation and autocomplete (Emacs default):
;;(setq tab-always-indent 'complete)



;;(global-set-key (kbd "C-x") 'kill-region)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;This is for global back-tab(go 4 spcaes front)

;; Use spaces instead of literal tab characters
(setq-default indent-tabs-mode nil)

;; Set tab width to 4 spaces
(setq-default tab-width 4)
(setq tab-stop-list (number-sequence 4 200 4))

;; Make TAB always insert 4 spaces anywhere
(global-set-key (kbd "<tab>") 'tab-to-tab-stop)

;; Force TAB to insert 4 spaces even inside C/programming modes
(global-set-key (kbd "<tab>") (lambda () (interactive) (insert "    ")))






;;This is for global back-tab(go back 4 spcaes)
;; Shift+TAB: un-indent highlighted region by 4 spaces, or delete up to 4 spaces before cursor
(global-set-key (kbd "<backtab>")
                (lambda ()
                  (interactive)
                  (if (use-region-p)
                      (indent-rigidly (region-beginning) (region-end) -4)
                    (let ((spaces 0))
                      (while (and (< spaces 4)
                                  (not (bolp))
                                  (eq (char-before) ?\s))
                        (delete-char -1)
                        (setq spaces (1+ spaces)))))))

                        


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;;stops the cursor from blinking
(blink-cursor-mode 1)


;;(setq-default cursor-type 'bar)
(setq-default cursor-type 'bar)

(set-cursor-color "#FFFFFF")

(require 'hl-line)

;; ;; Highlight the current line everywhere (like CLion)
;; ;; This is the general idea
(global-hl-line-mode 1)


;; Subtle dark-gray current-line highlight matching your screenshot
(set-face-background 'hl-line "#2b2d30")

;; Keep syntax highlighting colors visible on the highlighted line
(set-face-foreground 'highlight nil)


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








;; (use-package treemacs
;;   :ensure t
;;   :bind
;;   ("C-c t" . treemacs))




(use-package treemacs
  :ensure t
  :defer t
  :bind
  (("M-q"   . treemacs-select-window)
   ("C-c t" . treemacs))
  :custom
  (treemacs-width 32)
  (treemacs-position 'left)
  (treemacs-indentation 2)
  (treemacs-indentation-string " ")
  (treemacs-collapse-dirs 0)             ;; Stop turning folders into ".cache/c"
  (treemacs-show-hidden-files t)         ;; Show .cache and .github like CLion
  (treemacs-follow-after-init nil)
  (treemacs-is-never-other-window t)
  (treemacs-no-png-images t)
  (treemacs-silent-refresh t)
  (treemacs-silent-filewatch t)
  :config
  (treemacs-follow-mode -1)
  (treemacs-filewatch-mode 1)
  (treemacs-project-follow-mode 1)
  (treemacs-git-mode 'deferred)

  ;; Hide .idea just like CLion does
  (add-to-list 'treemacs-ignored-file-predicates
               (lambda (filename _absolute-path)
                 (string-equal filename ".idea")))

  ;; Single-click folders/files
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))

(use-package treemacs-nerd-icons
  :ensure t
  :after treemacs
  :config
  (treemacs-load-theme "nerd-icons"))

;; Match CLion's exact New UI sidebar colors & font size
(with-eval-after-load 'treemacs
  (set-face-attribute 'treemacs-window-background-face nil :background "#2b2d30")
  (set-face-attribute 'treemacs-hl-line-face nil :background "#393b40" :extend t)
  (set-face-attribute 'treemacs-root-face nil :foreground "#dfe1e5" :height 0.95 :weight 'bold)
  ;; Make normal folders crisp light-gray instead of blue
  (set-face-attribute 'treemacs-directory-face nil :foreground "#dfe1e5" :height 0.92)
  (set-face-attribute 'treemacs-directory-collapsed-face nil :foreground "#dfe1e5" :height 0.92)
  (set-face-attribute 'treemacs-file-face nil :foreground "#dfe1e5" :height 0.92)
  ;; Make git-ignored folders (build, cmake-build-debug) warm tan/brown like CLion
  (set-face-attribute 'treemacs-git-ignored-face nil :foreground "#b5895a" :height 0.92)
  (set-face-attribute 'treemacs-git-modified-face nil :foreground "#548af7" :height 0.92)
  (set-face-attribute 'treemacs-git-untracked-face nil :foreground "#cf8e6d" :height 0.92))





(defun my-treemacs-custom-background ()
  "Set a distinct background color for the Treemacs side panel."
  (face-remap-add-relative 'default '(:background "#2b2d30"))
  ;; Optional: Also match the empty margin/fringe area on the left edge
  (face-remap-add-relative 'fringe '(:background "#2b2d30")))

(add-hook 'treemacs-mode-hook 'my-treemacs-custom-background)







(with-eval-after-load 'treemacs
  (setq treemacs-width-is-initially-locked nil)
  (setq treemacs-width 45)) ;; Default starting width



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









;; ;; 1. Disable Emacs's mouse-over text highlight globally (or in Treemacs)
;; (add-hook 'treemacs-mode-hook
;;           (lambda ()
;;             (setq-local mouse-highlight nil)))




;; 1. Eliminate Emacs C-level mouse-hover & display throttling
(setq mouse-highlight nil)                 ;; Disable slow C-level mouse-face hover redraws completely
(setq fast-but-imprecise-scrolling nil)
(setq redisplay-skip-fontification-on-input nil)
(setq jit-lock-defer-time 0)               ;; Never delay visual updates
(setq idle-update-delay 0.05)              ;; Instant UI updates

;; 2. Strip out Treemacs background timers & heavy visual overlays
(with-eval-after-load 'treemacs
  (treemacs-git-mode -1)                   ;; Stop spawning background 'git status' processes
  (treemacs-filewatch-mode -1)             ;; Stop constant inotify directory re-rendering
  (treemacs-fringe-indicator-mode -1))     ;; Remove fringe indicator tracking

(add-hook 'treemacs-mode-hook
          (lambda ()
            (setq-local mouse-highlight nil)
            (hl-line-mode -1)              ;; Disable per-line overlay recalculation in sidebar
            (display-line-numbers-mode -1)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;














;;MAKE SWTICH BUFFER KEY BIDING SOMETHING EASY NOT C-x b


(add-hook 'c++-ts-mode-hook
          (lambda ()
            (setq c-ts-mode-indent-offset 4)
            (setq tab-width 4)
            (setq indent-tabs-mode nil)))



(setq-local c-ts-mode-indent-offset 4)



(setq c-default-style "linux"
      c-basic-offset 4)


(electric-pair-mode 1)

;; ;; 2. Stop ':', '{', '}', ';', etc. from auto-indenting in C and C++
;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (c-toggle-electric-state -1)))






;; 1. Keep Enter aligned with the current line (never drops to column 0)
;;(electric-indent-mode 1)


;; Force Enter (RET) to ALWAYS indent the new line to match the current line
(global-set-key (kbd "RET") 'newline-and-indent)













;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; (use-package treesit-auto
;;   :config
;;   (global-treesit-auto-mode))








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








;; Ensure GNU ELPA and MELPA package archives are available
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org") t)
(package-initialize)

;; Enable CLion-style automatic completion popups (Corfu)
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)                 ;; Automatically show popup while typing
  (corfu-auto-delay 0.1)         ;; Fast 0.1s popup delay like CLion
  (corfu-auto-prefix 1)          ;; Show suggestions after typing just 1 character
  (corfu-cycle t)                ;; Allow cycling through candidates
  :init
  (global-corfu-mode))



;; ;; 1. Disable Flycheck so it doesn't throw raw compiler flag errors
;; (global-flycheck-mode -1)
;; (add-hook 'c-mode-common-hook (lambda () (flycheck-mode -1)))
;; (add-hook 'c++-ts-mode-hook (lambda () (flycheck-mode -1)))

;; Automatically start clangd (Eglot) in C and C++ files
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'c-ts-mode-hook 'eglot-ensure)
(add-hook 'c++-ts-mode-hook 'eglot-ensure)













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






































;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;













;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







;; Force font-lock-type-face AND clangd semantic types to #3A7BBB blue
(set-face-attribute 'font-lock-type-face nil :foreground "#3A7BBB")

(with-eval-after-load 'eglot
  (when (facep 'eglot-semantic-type)
    (set-face-attribute 'eglot-semantic-type nil :foreground "#3A7BBB")))

