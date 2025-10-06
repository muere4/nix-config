{ config, pkgs, lib, ... }:

let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixi" ]; # Solo en el host "nixi"
  
  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Configuración de Wayland con KDE Plasma 6
    services.desktopManager.plasma6.enable = true;
    
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true; # Habilita Wayland en SDDM
      };
      defaultSession = "plasma"; # Sesión Plasma con Wayland por defecto
    };

    # Paquetes extra de KDE Plasma
    environment.systemPackages = with pkgs; [
      kdePackages.konsole
      kdePackages.dolphin
      kdePackages.kate
      kdePackages.gwenview
    ];



    # Home Manager: atajo solo para capturar región rectangular
    home-manager.users.muere = {
      programs.home-manager.enable = true;

      xdg.configFile."kglobalshortcutsrc".text = ''
        [Spectacle]
        RectangularRegionShortcut=Ctrl+ñ,none,Capture a rectangular region
      '';

      # Asociar tipos MIME con Kate
      xdg.mimeApps.defaultApplications = {
        "text/plain" = [ "org.kde.kate.desktop" ];
        "inode/directory" = [ "org.kde.dolphin.desktop" ]; # carpetas → Dolphin
        "application/octet-stream" = [ "org.kde.kate.desktop" ]; # archivos sin tipo → Kate
      };

    };
  };
}
