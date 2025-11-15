{ config, pkgs, lib, ... }:
let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixi" ]; # Solo en nixos
  userName = "muere";
  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      epiphany
      geary
    ];
    
    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.appindicator
      gnomeExtensions.tray-icons-reloaded
      gnomeExtensions.removable-drive-menu
      gnomeExtensions.blur-my-shell
      gnomeExtensions.dash-to-dock
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.pop-shell
      gnomeExtensions.transparent-window-moving
      gnomeExtensions.caffeine
      gnomeExtensions.user-themes
      # Capturas de pantalla
      flameshot
      # Necesario para Flameshot en Wayland
      xdg-desktop-portal
      xdg-desktop-portal-gnome
    ];
    
    # Configurar asociaciones de archivos por defecto
    xdg.mime = {
      enable = true;
      defaultApplications = {
        "text/plain" = "org.gnome.TextEditor.desktop";
        "text/x-nix" = "org.gnome.TextEditor.desktop";
        "text/x-python" = "org.gnome.TextEditor.desktop";
        "text/x-shellscript" = "org.gnome.TextEditor.desktop";
        "text/x-csrc" = "org.gnome.TextEditor.desktop";
        "text/x-c++src" = "org.gnome.TextEditor.desktop";
        "text/x-java" = "org.gnome.TextEditor.desktop";
        "text/javascript" = "org.gnome.TextEditor.desktop";
        "text/html" = "org.gnome.TextEditor.desktop";
        "text/css" = "org.gnome.TextEditor.desktop";
        "text/xml" = "org.gnome.TextEditor.desktop";
        "text/markdown" = "org.gnome.TextEditor.desktop";
        "application/json" = "org.gnome.TextEditor.desktop";
        "application/x-yaml" = "org.gnome.TextEditor.desktop";
        "application/xml" = "org.gnome.TextEditor.desktop";
      };
    };

    # Variables de entorno para mejorar rendimiento
    environment.variables = {
      GSK_RENDERER = "ngl";
    };

    # Configuración de Home Manager para temas
    home-manager.users.${userName} = { config, ... }: {
      # Tema oscuro y color de acento morado
      dconf.settings = {
        # Tema de color (oscuro) y acento
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          accent-color = "purple";  # GNOME 47+
        };

        
        # Atajos de teclado personalizados para Flameshot
        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/flameshot" = {
          name = "Flameshot";
          # Usar script wrapper para Wayland
          command = "sh -c 'QT_QPA_PLATFORM=wayland flameshot gui'";
          binding = "<Control>ntilde";  # Ctrl+Ñ
        };
      };

     
    };
  };
}
