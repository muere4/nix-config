{pkgs, utils, ...}:
let
  defaultGlobalEnv =
    { packages = with pkgs; [
        curl
        httpie
        jq
        s3cmd
        # Herramientas adicionales útiles para desarrollo
        tree
        ripgrep  # Mejor grep para Neovim
        fd       # Mejor find para Neovim
        bat      # Mejor cat con syntax highlighting
      ];
      imports = [];

      # Configuración de Emacs comentada - mantenida para referencia
      # emacsExtraPackages = utils.function.const [];
      # emacsExtraConfig = "";
    };

  gitEnv =
    { packages = with pkgs; [ ];
      imports = [ (utils.constImport ./git.nix) ];

      # Configuración de Emacs comentada - mantenida para referencia
      # emacsExtraPackages = epkgs: [epkgs.magit];
      # emacsExtraConfig = "";
    };

in utils.env.concatEnvironments [ defaultGlobalEnv gitEnv ]
