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

      # Build tools para vterm
      cmake
      gnumake
    ];

    home-manager.users.${userName} = { config, ... }: {
      # Solo agregar bin al PATH, Doom usa defaults
      home.sessionPath = [ "$HOME/.config/emacs/bin" ];


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
        hasklig

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



      # Aliases útiles
      programs.bash.shellAliases = {
        doom = "${config.xdg.configHome}/emacs/bin/doom";
        doom-install = "${config.xdg.configHome}/emacs/bin/doom install";
        doom-sync = "${config.xdg.configHome}/emacs/bin/doom sync";
        doom-upgrade = "${config.xdg.configHome}/emacs/bin/doom upgrade";
        doom-doctor = "${config.xdg.configHome}/emacs/bin/doom doctor";
      };


    };
  };
}
