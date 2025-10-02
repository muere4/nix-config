;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Configuración para C# y OmniSharp
(after! csharp-mode
  ;; Habilitar LSP automáticamente
  (add-hook 'csharp-mode-hook #'lsp!)

  ;; Configuración de indentación
  (setq c-basic-offset 4)
  (setq csharp-tree-sitter-indent-offset 4))

;; Configuración específica de LSP para C#
(after! lsp-mode
  ;; OmniSharp configuration
  (setq lsp-csharp-server-path "omnisharp")

  ;; Mejorar rendimiento
  (setq lsp-idle-delay 0.1)
  (setq lsp-log-io nil) ; Solo para debug, desactívalo normalmente

  ;; Configuración de autocompletado
  (setq lsp-completion-enable t)
  (setq lsp-completion-show-detail t)
  (setq lsp-completion-show-kind t))

;; Mejorar company-mode para C#
(after! company
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1)
  (setq company-show-numbers t))


(map! :leader
      (:prefix-map ("o" . "open")
       "t" #'+vterm/here))



(setq org-roam-directory (file-truename "~/org-roam/"))

(use-package! org-roam
  :custom
  (org-roam-directory (file-truename "~/org-roam/"))
  :config
  (org-roam-db-autosync-mode))

(map! :leader
      :desc "Find node" "n r f" #'org-roam-node-find
      :desc "Insert node" "n r i" #'org-roam-node-insert
      :desc "Toggle roam buffer" "n r r" #'org-roam-buffer-toggle)

;; Que los buffers de org-roam no sean pop-ups
(setq org-roam-buffer-visibility 'default)

;; Alternativa: forzar a que use split vertical
(setq display-buffer-alist
      (append
       '(("\\*org-roam\\*"
          (display-buffer-reuse-window display-buffer-same-window)
          ;; (display-buffer-in-side-window) ;; <- si quisieras side-window
          ))
       display-buffer-alist))



