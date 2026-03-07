(setq doom-theme 'doom-dark+)

(setq doom-font (font-spec :family "GeistMono NerdFont Mono" :size 16 :weight 'semi-bold))

(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq default-frame-alist '((undecorated . t)))
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(setq confirm-kill-emacs nil)

(map! :leader "w" #'save-buffer)

(map! :leader "\\" #'evil-window-vsplit)
(map! :leader "|" #'evil-window-split)

(map! "C-h" #'evil-window-left)
(map! "C-j" #'evil-window-down)
(map! "C-k" #'evil-window-up)
(map! "C-l" #'evil-window-right)

(map! :leader "C" #'kill-current-buffer)

(setq projectile-enable-caching nil)

(defun custom/find-file ()
  (interactive)
  (call-interactively (if (projectile-project-p) (projectile-find-file) #'find-file)))
(map! :nvi "C-p" #'custom/find-file)

(defun custom/new-terminal-tab ()
  (interactive)
  (tab-new)
  (+vterm/here nil))

(map! :leader "SPC" nil)
(map! :leader
      "L" #'tab-next
      "H" #'tab-previous
      "C" #'tab-close
      "N" #'tab-new
      "T" #'custom/new-terminal-tab)

(after! orderless
  (setq orderless-matching-styles
        '(orderless-literal orderless-regexp orderless-flex)))

(setq vterm-shell "/bin/fish")

(evil-define-operator my/evil-delete-no-yank (beg end type register yank-handler)
  (interactive "<R><x>")
  (evil-delete beg end type ?_ yank-handler))

(define-key evil-normal-state-map "d" #'my/evil-delete-no-yank)
(define-key evil-visual-state-map "d" #'my/evil-delete-no-yank)
(define-key evil-visual-state-map "d" #'my/evil-delete-no-yank)
(define-key evil-visual-state-map "d" #'my/evil-delete-no-yank)

(map! :leader
      "d" #'evil-delete)

(defun my/evil-visual-paste-no-yank (count &optional register)
  (interactive "p")
  (let ((evil-this-register ?_))
    (evil-visual-paste count register)))

(define-key evil-visual-state-map "p" #'my/evil-visual-paste-no-yank)
(define-key evil-visual-state-map "P" #'evil-visual-paste)

(map! :leader
      "e" #'dirvish)

(map! :leader
      "u" #'undo-tree-visualize)

(map! :map dirvish-mode-map
      :n "a" #'dired-create-empty-file
      :n "c" #'dired-do-copy)

(use-package! copilot
  :bind (:map copilot-completion-map
              ("M-e" . 'copilot-accept-completion)
              ("M-E" . 'copilot-accept-completion-by-word)
              ("M-n" . 'copilot-next-completion)
              ("M-p" . 'copilot-previous-completion)))

(use-package! lsp-tailwindcss :after lsp-mode)

(add-to-list 'copilot-indentation-alist '(prog-mode 4))

(map! :leader
      :prefix "l"
      "t" #'copilot-mode)

(map! :n "<f2>" #'lsp-rename)

(after! corfu
  (setq corfu-auto t
        corfu-auto-prefix 0
        corfu-auto-delay 0.2))
