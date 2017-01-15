;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
          (normal-top-level-add-subdirs-to-load-path))))))
;; カラー
(load-theme 'manoj-dark t)

;; 引数のディレクトリとそのサブディレクトリを load-path に追加
(add-to-load-path "elisp" "elpa")

;; Mac OS X の場合のファイル名の設定
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))

;; dired
(add-hook 'dired-load-hook (lambda ()(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)))
(setq dired-dwim-target t)

;; リージョンないの行数と文字数をモードラインを表示する（範囲指定時のみ）
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
    ""))

(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))

;; 自動閉じ括弧
(electric-pair-mode t)

;; 現在行のハイライト
(global-hl-line-mode t)

;; 対応する括弧のハイライト
(show-paren-mode t) ; 有効化

;; 行数の表示
(global-linum-mode t)

;; paren のスタイル : expression は括弧内も強調表示
(setq show-paren-style 'expression)

;; 10 行移動
(global-set-key "\M-n" (kbd "C-u 10 C-n"))
(global-set-key "\M-p" (kbd "C-u 10 C-p"))

;; タブの無効化
(setq-default indent-tabs-mode nil)
;;(global-whitespace-mode t)

;; バックアップを作らない
(setq make-backup-files nil)
(setq auto-save-default nil)

;; yatex
(setq auto-mode-alist
            (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq YaTeX-prefix "\C-t")
(setq tex-command "platex")
(setq bibtex-command "pbibtex")
(setq dviprint-command-format "dvipdfmx %s")
;; use utf-8 on yatex mode
;; (setq YaTeX-kanji-code 4)

;; reftex-mode
(add-hook 'yatex-mode-hook 'turn-on-reftex)

;; ido
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)

;; 自動インストール用
(defvar my-favorite-package-list
  '(auto-complete
    undohist
    undo-tree
    multi-term
    magit
    jedi
    flycheck
    ido-vertical-mode
    ido-ubiquitous
    smex)
  "packages to be installed")

;; elpa の設定
(require 'package)
(add-to-list 'package-archives '("melpa"."http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade"."http://marmalade-repo.org/packages/"))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(dolist (pkg my-favorite-package-list)
  (unless (package-installed-p pkg)
        (package-install pkg)))

;; 自動補完の設定 (auto-complete)
(require 'auto-complete)
(ac-config-default)

;; 編集履歴の記憶 (undohist)
(require 'undohist)
(undohist-initialize)

;; アンドゥの分岐履歴 (undo-tree)
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

;; シェルの利用 (multi-term)
(when (require 'multi-term nil t)
  (setq mult-term-programm "/bin/zsh"))

;; git の設定 (magit)
(require 'magit)

;; jedi の設定 (jedi)
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; flycheck の設定 (flycheck)
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
(define-key global-map (kbd "\C-cn") 'flycheck-next-error)
(define-key global-map (kbd "\C-cp") 'flycheck-previous-error)
(define-key global-map (kbd "\C-cd") 'flycheck-list-errors)

;; ido-vertical-mode
(require 'ido-vertical-mode)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)

;; ido-ubiquitous-mode
(require 'ido-ubiquitous)
(ido-ubiquitous-mode 1)

;;smex
(require 'smex)
(global-set-key(kbd "M-x") 'smex)

;; yasnippet
(require 'yasnippet)
(yas-global-mode 1)
(setq yas-prompt-functions '(yas-ido-prompt))
(setq yas-snippet-dirs
      '("~/.emacs.d/mysnippets"
        "~/.emacs.d/yasnippets"))
