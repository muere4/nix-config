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
        wayland.enable = true;
      };
      defaultSession = "plasma";
    };

    # Paquetes extra de KDE Plasma
    environment.systemPackages = with pkgs; [
      kdePackages.konsole
      kdePackages.dolphin
      kdePackages.kate
      kdePackages.gwenview
    ];

    # Home Manager con plasma-manager
    home-manager.users.muere = {
      programs.home-manager.enable = true;

      # Habilitar plasma-manager
      programs.plasma = {
        enable = true;

        # Configuración de Spectacle
        spectacle.shortcuts = {
          captureRectangularRegion = "Ctrl+ñ";
        };

        # Configuración del panel inferior con gestor de tareas
        panels = [
          {
            location = "bottom";
            height = 44;
            widgets = [
              {
                name = "org.kde.plasma.kickoff";
              }
              {
                name = "org.kde.plasma.icontasks";
                config = {
                  General = {
                    launchers = [
                      "applications:org.kde.konsole.desktop"
                      "applications:org.kde.dolphin.desktop"
                      "applications:microsoft-edge.desktop"
                    ];
                  };
                };
              }
              "org.kde.plasma.marginsseparator"
              {
                systemTray.items = {
                  shown = [
                    "org.kde.plasma.networkmanagement"
                    "org.kde.plasma.volume"
                  ];
                };
              }
              {
                name = "org.kde.plasma.digitalclock";
              }
            ];
          }
        ];
      };

      # Asociar tipos MIME con Kate
      xdg.mimeApps.defaultApplications = {
        "text/plain" = [ "org.kde.kate.desktop" ];
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
        "application/octet-stream" = [ "org.kde.kate.desktop" ];
      };
    };
  };
}
