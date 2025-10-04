{ config, pkgs, lib, ... }:
let
  enabledHosts = [ "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;

  # Usar un commit específico en lugar de master para reproducibilidad
  doomEmacsSrc = pkgs.fetchFromGitHub {
    owner = "doomemacs";
    repo = "doomemacs";
    rev = "master";  # O especifica un commit/tag específico
    sha256 = "sha256-Y67ooUjDMWjPk+/IjMRnhe+OPn19Q0wF73prtExwyiI=";
  };
in
{
  config = lib.mkIf enabled {
    # Paquetes a nivel de sistema
    environment.systemPackages = with pkgs; [
      emacs
      # .NET Development
      dotnet-sdk_8
      omnisharp-roslyn
      # Build tools para vterm
      cmake
      gnumake
    ];

    # Configuración de Home Manager
    home-manager.users.${userName} = { config, ... }: {
      # Variables de entorno para Doom Emacs
      home.sessionVariables = {
        DOOMDIR = "${config.xdg.configHome}/doom";
        EMACSDIR = "${config.xdg.configHome}/emacs";
        DOOMLOCALDIR = "${config.xdg.dataHome}/doom";
        DOOMPROFILELOADFILE = "${config.xdg.stateHome}/doom-profiles-load.el";
      };

      # Agregar doom/bin al PATH
      home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

      # Paquetes para Doom Emacs
      home.packages = with pkgs; [
        # Herramientas core de Doom
        fd
        (ripgrep.override { withPCRE2 = true; })
        coreutils
        clang

        # Build tools para vterm
        cmake
        gnumake
        libtool

        # Utilidades adicionales
        shellcheck
        pandoc
        graphviz
        sqlite-interactive
        nixfmt-classic

        # Fuentes
        emacs-all-the-icons-fonts
        fontconfig
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.droid-sans-mono
        nerd-fonts.symbols-only

        # Emacs packages
        emacsPackages.vterm
        emacsPackages.pdf-tools
        emacsPackages.omnisharp
      ];

      # Habilitar fontconfig
      fonts.fontconfig.enable = true;

      # Emacs
      programs.emacs = {
        enable = true;
        package = pkgs.emacs;
      };

      # Doom Emacs source
      xdg.configFile."emacs" = {
        source = doomEmacsSrc;
        onChange = ''
          if [ ! -d "${config.xdg.configHome}/emacs/.git" ]; then
            ${pkgs.git}/bin/git -C "${config.xdg.configHome}/emacs" init
          fi
        '';
      };

      # Tu configuración personal de Doom
      xdg.configFile."doom".source = ../../doom;

      # Aliases útiles
      programs.bash.shellAliases = {
        doom = "${config.xdg.configHome}/emacs/bin/doom";
        doom-sync = "${config.xdg.configHome}/emacs/bin/doom sync";
        doom-upgrade = "${config.xdg.configHome}/emacs/bin/doom upgrade";
        doom-doctor = "${config.xdg.configHome}/emacs/bin/doom doctor";
      };

      programs.zsh.shellAliases = {
        doom = "${config.xdg.configHome}/emacs/bin/doom";
        doom-sync = "${config.xdg.configHome}/emacs/bin/doom sync";
        doom-upgrade = "${config.xdg.configHome}/emacs/bin/doom upgrade";
        doom-doctor = "${config.xdg.configHome}/emacs/bin/doom doctor";
      };
    };
  };
}
