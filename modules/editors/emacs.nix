{ config, pkgs, lib, ... }:
let
  enabledHosts = [ "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Paquetes a nivel de sistema
    environment.systemPackages = with pkgs; [
      emacs                     
      fd
      coreutils
      clang
      shellcheck    
      pandoc
      graphviz
      sqlite-interactive
      (ripgrep.override { withPCRE2 = true; })
      
      # .NET Development
      dotnet-sdk_8
      omnisharp-roslyn
      
      # Emacs packages
      emacsPackages.vterm
    ];

    # Configuración de Home Manager para el usuario
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

      # Paquetes específicos de Doom
      home.packages = with pkgs; [
        fd
        (ripgrep.override { withPCRE2 = true; })
        nixfmt
        emacs-all-the-icons-fonts
        fontconfig
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.droid-sans-mono
        emacsPackages.pdf-tools
        emacsPackages.omnisharp
        emacsPackages.vterm
      ];

      # Habilitar fontconfig
      fonts.fontconfig.enable = true;

      # Emacs habilitado
      programs.emacs = {
        enable = true;
        package = pkgs.emacs;
      };

      # Descargar Doom Emacs - ÚLTIMA VERSIÓN con fetchTarball
      xdg.configFile."emacs" = {
	  source = builtins.fetchTarball {
	    url = "https://github.com/doomemacs/doomemacs/archive/master.tar.gz";
	    sha256 = "08naf16b8svsxw2lqhvxglz8xvw5cz28rj7gjg7nhcf392hyibk3";  # Pegá el hash aquí
	  };
	};

      # Tu configuración personal de Doom
      xdg.configFile."doom".source = ../../doom;

      # Aliases útiles
      programs.bash.shellAliases = {
        doom = "~/.config/emacs/bin/doom";
        doom-sync = "~/.config/emacs/bin/doom sync";
        doom-upgrade = "~/.config/emacs/bin/doom upgrade";
        doom-doctor = "~/.config/emacs/bin/doom doctor";
      };
    };
  };
}
