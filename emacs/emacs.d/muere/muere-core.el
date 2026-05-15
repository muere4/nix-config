;;; muere-core --- core functionality -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(add-to-list 'load-path "~/.config/emacs/muere/core")
(require 'muere-package)
(require 'muere-defaults)
(require 'muere-utility)
(require 'muere-evil)
(require 'muere-hydra)
(require 'muere-dispatcher)
(require 'muere-projectile)

(provide 'muere-core)
;;; muere-core.el ends here
