{ config, pkgs, inputs, unstable, ... }:

{
  # Información básica del usuario
  home.username = "muere";
  home.homeDirectory = "/home/muere";

  # Versión de Home Manager
  home.stateVersion = "25.05";

  # Paquetes que quieres instalar para tu usuario
  home.packages = with pkgs; [
    # Herramientas básicas
    htop
    tree
    unzip

    # Desarrollo
    vscode

    # Multimedia
    vlc

    # Ejemplo de paquete del canal unstable:
    # unstable.discord

    # Navegadores adicionales
    brave
  ];

  # Configuración de programas
  programs = {
    # Habilitar Home Manager para que se gestione a sí mismo
    home-manager.enable = true;

    # Configuración de Git
    git = {
      enable = true;
      userName = "muere4";
      userEmail = "muere4@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "kate"; # o "kate", "code", "vim", etc.
        color.ui = "auto";
  };
    };

    # Bash
    bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        # Alias personalizados
        alias ll='ls -la'
        alias la='ls -la'
        alias ..='cd ..'
        alias ...='cd ../..'
      '';
    };

    # Configuración de direnv (opcional, útil para proyectos con flakes)
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  # Variables de entorno
  home.sessionVariables = {
    EDITOR = "kate";
    BROWSER = "microsoft-edge";
  };

  # XDG default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "microsoft-edge.desktop";
      "text/html" = "microsoft-edge.desktop";
      "text/xml" = "microsoft-edge.desktop";
      "x-scheme-handler/http" = "microsoft-edge.desktop";
      "x-scheme-handler/https" = "microsoft-edge.desktop";
      "x-scheme-handler/about" = "microsoft-edge.desktop";
      "x-scheme-handler/unknown" = "microsoft-edge.desktop";
    };
  };


  # Configuración de archivos de dotfiles (opcional)
  # home.file.".config/example/config.toml".text = ''
  #   # Contenido de configuración
  # '';
}
