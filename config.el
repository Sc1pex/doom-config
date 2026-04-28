(assoc-delete-all "\\.svelte\\'" auto-mode-alist)
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . svelte-ts-mode))

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

(use-package! svelte-ts-mode
  :mode "\\.svelte\\'"
  :config
  (after! lsp-mode
    (add-to-list 'lsp-language-id-configuration '(svelte-ts-mode . "svelte"))
    ;; Ensure lsp-mode knows to watch svelte-ts-mode
    (lsp-register-client
     (make-lsp-client :new-connection (lsp-stdio-connection '("svelteserver" "--stdio"))
                      :major-modes '(svelte-ts-mode)
                      :server-id 'svelte-ls)))

  (add-hook 'svelte-ts-mode-hook #'lsp-deferred))

(add-to-list 'copilot-indentation-alist '(prog-mode 4))

(map! :leader
      :prefix "l"
      "t" #'copilot-mode)

(map! :n "<f2>" #'lsp-rename)

(after! corfu
  (setq corfu-auto t
        corfu-auto-prefix 0
        corfu-auto-delay 0.2))

(after! rustic
  (setq rustic-rustfmt-args '("--edition", "2024")))

(after! lsp-mode
  (setq lsp-auto-execute-action nil))

(after! treesit
  (setq treesit-language-source-alist
        (append treesit-language-source-alist
                '((svelte . ("https://github.com/tree-sitter-grammars/tree-sitter-svelte"))
                  (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" nil
                                 "typescript/src"))
                  (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
                  (css . ("https://github.com/tree-sitter/tree-sitter-css"))))))

(after! apheleia
  (add-to-list 'apheleia-mode-alist '(svelte-ts-mode . prettier-svelte)))

(setq! c-ts-mode-indent-offset 4)
