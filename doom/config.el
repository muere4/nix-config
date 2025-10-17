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












;; Configuración de Org Babel para código con imágenes
(after! org
  ;; Habilitar lenguajes para Org Babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (shell . t)
     (emacs-lisp . t)
     (dot . t)        ; Graphviz
     (plantuml . t)   ; PlantUML (si lo usas)
     (C . t)
     (csharp . t)))

  ;; Configuración específica para Python
  (setq org-babel-python-command "python3")

  ;; Variables de entorno para Python (Fix Wayland)
  (setq org-babel-python-wrapper-method
        "MPLBACKEND=Agg python3 -c '%s'")

  ;; No pedir confirmación para evaluar código (opcional)
  (setq org-confirm-babel-evaluate nil)

  ;; Configuración para imágenes inline
  (setq org-image-actual-width '(600))  ; Ancho por defecto en píxeles

  ;; Auto-mostrar imágenes al abrir archivo
  (setq org-startup-with-inline-images t)

  ;; Mostrar imágenes inline automáticamente después de ejecutar
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

  ;; Redisplay más agresivo
  (add-hook 'org-babel-after-execute-hook
            (lambda () (org-redisplay-inline-images)) 'append))

;; Keybindings útiles
(map! :map org-mode-map
      :localleader
      :desc "Toggle inline images" "i i" #'org-toggle-inline-images
      :desc "Redisplay inline images" "i r" #'org-redisplay-inline-images
      :desc "Execute code block" "e" #'org-babel-execute-src-block)






;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Configuración de Org Babel para código con imágenes
(after! org
  ;; Habilitar lenguajes para Org Babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (shell . t)
     (emacs-lisp . t)
     (dot . t)        ; Graphviz
     (plantuml . t)   ; PlantUML (si lo usas)
     (C . t)
     (csharp . t)))

  ;; Configuración específica para Python
  (setq org-babel-python-command "python3")

  ;; Fix para archivos binarios en Org Babel Python
  (setq org-babel-python-wrapper-method
        "
def main():
%s

if __name__ == '__main__':
    main()")

  (setq org-babel-python-pp-wrapper-method
        "
import pprint
def main():
%s

if __name__ == '__main__':
    main()")

  ;; No pedir confirmación para evaluar código (opcional)
  (setq org-confirm-babel-evaluate nil)

  ;; Configuración para imágenes inline
  (setq org-image-actual-width '(600))  ; Ancho por defecto en píxeles

  ;; Auto-mostrar imágenes al abrir archivo
  (setq org-startup-with-inline-images t)

  ;; Mostrar imágenes inline automáticamente después de ejecutar
  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

  ;; Redisplay más agresivo
  (add-hook 'org-babel-after-execute-hook
            (lambda () (org-redisplay-inline-images)) 'append))

;; Keybindings útiles
(map! :map org-mode-map
      :localleader
      :desc "Toggle inline images" "i i" #'org-toggle-inline-images
      :desc "Redisplay inline images" "i r" #'org-redisplay-inline-images
      :desc "Execute code block" "e" #'org-babel-execute-src-block)

;; Autocompletado en bloques de código
(after! org
  (setq org-src-tab-acts-natively t)
  (setq org-src-fontify-natively t)
  (setq org-src-preserve-indentation t))

;; Habilitar company en org-src blocks
(add-hook 'org-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 '((company-capf company-dabbrev-code company-files)))))

;; Snippet personalizado para matplotlib
(after! org
  (defun my/org-insert-matplotlib-block ()
    "Inserta un bloque de código Python con matplotlib configurado."
    (interactive)
    (let ((filename (read-string "Nombre del archivo (sin .png): " "grafico")))
      (insert (format "#+begin_src python :results none
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# Tu código aquí

plt.savefig('%s.png', dpi=150, bbox_inches='tight')
plt.close()
#+end_src

#+RESULTS:

[[file:%s.png]]" filename filename))
      (forward-line -7)
      (end-of-line)))

  (map! :map org-mode-map
        :localleader
        :desc "Insert matplotlib block" "i p" #'my/org-insert-matplotlib-block))





;;; ============================================================================
;;; HASKELL CONFIGURATION
;;; ============================================================================
;; ============================================================================
;; Configuración de Haskell con LSP (haskell-language-server)
;; ============================================================================

(after! haskell-mode
  ;; ──────────────────────────────────────────────────────────────────────────
  ;; FORMATEADOR: Fourmolu (como Rebecca)
  ;; ──────────────────────────────────────────────────────────────────────────
  (setq haskell-formatter-command "fourmolu")

  ;; Formatear en save (opcional, descomenta si quieres)
  ;; (add-hook 'haskell-mode-hook
  ;;           (lambda () (add-hook 'before-save-hook #'haskell-format-buffer nil t)))

  ;; ──────────────────────────────────────────────────────────────────────────
  ;; VISUAL: Rainbow delimiters y line numbers (como Rebecca)
  ;; ──────────────────────────────────────────────────────────────────────────
  ;; Rainbow delimiters (solo si está disponible)
  (when (featurep 'rainbow-delimiters)
    (add-hook 'haskell-mode-hook #'rainbow-delimiters-mode))

  (add-hook 'haskell-mode-hook #'display-line-numbers-mode)

  ;; ──────────────────────────────────────────────────────────────────────────
  ;; KEYBINDINGS LOCALES (estilo Rebecca)
  ;; ──────────────────────────────────────────────────────────────────────────
  (map! :map haskell-mode-map
        :localleader
        ;; Formateo
        :desc "Format buffer" "=" #'haskell-format-buffer

        ;; REPL/Interactive (heredado de haskell-mode)
        :desc "Load file in REPL" "l" #'haskell-process-load-file
        :desc "Switch to REPL" "z" #'haskell-interactive-switch

        ;; Type info (usando haskell-mode, no LSP)
        (:prefix ("n" . "info")
         :desc "Type at point" "t" #'haskell-process-do-type
         :desc "Info at point" "i" #'haskell-process-do-info)

        ;; Build
        (:prefix ("c" . "cabal")
         :desc "Build" "b" #'haskell-process-cabal-build
         :desc "Cabal" "c" #'haskell-process-cabal))

  ;; Navegación de S-expressions (como Rebecca)
  (map! :map haskell-mode-map
        :n "C-)" #'forward-sexp
        :n "C-(" #'backward-sexp)

  ;; ──────────────────────────────────────────────────────────────────────────
  ;; CONFIGURACIÓN DEL PROCESO INTERACTIVO (como Rebecca)
  ;; ──────────────────────────────────────────────────────────────────────────
  (setq haskell-process-suggest-remove-import-lines t
        haskell-process-auto-import-loaded-modules t
        haskell-process-log t
        haskell-tags-on-save nil) ; Tags desactivados (usa LSP)

  ;; ──────────────────────────────────────────────────────────────────────────
  ;; CABAL MODE (como Rebecca)
  ;; ──────────────────────────────────────────────────────────────────────────
  (map! :map haskell-cabal-mode-map
        :localleader
        :desc "Switch to REPL" "z" #'haskell-interactive-switch
        :desc "Clear REPL" "k" #'haskell-interactive-mode-clear
        :desc "Build" "c" #'haskell-process-cabal-build
        :desc "Cabal command" "C" #'haskell-process-cabal)

  ;; S-expressions para cabal también
  (map! :map haskell-cabal-mode-map
        :n "C-)" #'forward-sexp
        :n "C-(" #'backward-sexp))

;; ============================================================================
;; LSP MODE PARA HASKELL (HLS)
;; ============================================================================
;; IMPORTANTE: Usar use-package! en lugar de after! para mejor control
(use-package! lsp-haskell
  :after lsp-mode
  :config
  ;; ──────────────────────────────────────────────────────────────────────────
  ;; CONFIGURACIÓN DE HLS
  ;; ──────────────────────────────────────────────────────────────────────────
  (setq lsp-haskell-server-path "haskell-language-server-wrapper")

  ;; Performance (como tu config de C#)
  (setq lsp-idle-delay 0.1
        lsp-log-io nil) ; Activa para debug

  ;; Completado
  (setq lsp-completion-enable t
        lsp-completion-show-detail t
        lsp-completion-show-kind t)

  ;; HLS-specific settings
  (setq lsp-haskell-formatting-provider "fourmolu") ; Usa fourmolu desde HLS

  ;; Plugin settings (ajusta según necesites)
  (setq lsp-haskell-plugin-ghcide-type-lenses-global-on nil)) ; Desactiva type lenses si molestan

;; Forzar LSP en haskell-mode
(add-hook! 'haskell-mode-hook
  (defun +haskell-lsp-setup-h ()
    "Forzar inicio de LSP en Haskell."
    (when (and (bound-and-true-p lsp-mode)
               (not lsp--buffer-workspaces))
      (lsp-deferred))))

;; Asegurar que lsp! se ejecute
(add-hook 'haskell-mode-hook #'lsp! 'append)
(add-hook 'haskell-literate-mode-hook #'lsp! 'append)

;; ============================================================================
;; LSP-UI (interfaz visual para LSP)
;; ============================================================================
(after! lsp-ui
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-show-with-cursor t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-diagnostics t))

;; ============================================================================
;; COMPANY MODE (autocompletado - como tu config de C#)
;; ============================================================================
(after! company
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1
        company-show-numbers t))

;; ============================================================================
;; UTILIDADES ADICIONALES
;; ============================================================================

;; Función para formatear buffer con fourmolu
(defun haskell-format-buffer ()
  "Format current buffer with fourmolu."
  (interactive)
  (let ((p (point)))
    (shell-command-on-region (point-min) (point-max)
                             haskell-formatter-command
                             nil t)
    (goto-char p)))

;; Función para ver tipo en punto actual (fallback si HLS no responde)
(defun haskell-show-type-fallback ()
  "Show type at point using haskell-mode if LSP fails."
  (interactive)
  (condition-case nil
      (lsp-describe-thing-at-point)
    (error (haskell-process-do-type))))

;; ============================================================================
;; KEYBINDINGS GLOBALES PARA HASKELL
;; ============================================================================
(map! :after haskell-mode
      :map haskell-mode-map
      :localleader
      ;; Quick access
      :desc "Type at point (LSP)" "t" #'lsp-describe-thing-at-point
      :desc "Find definition" "d" #'lsp-find-definition
      :desc "Find references" "r" #'lsp-find-references
      :desc "Rename" "R" #'lsp-rename)

;; ============================================================================
;; HOOKS FINALES
;; ============================================================================
(add-hook! 'haskell-mode-hook
  ;; Auto-completado agresivo
  (setq-local company-idle-delay 0.1)

  ;; Columna de 80 caracteres (como Rebecca)
  ;;(setq-local fill-column 80)

  ;; Mostrar columna
  ;;(display-fill-column-indicator-mode 1))
