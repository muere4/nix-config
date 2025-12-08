{ config, pkgs, lib, ... }:

let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixi" ]; # Solo en el host "nixi"

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {


  # FIX para variables de entorno excesivamente largas
    # https://github.com/NixOS/nixpkgs/issues/126590#issuecomment-3194531220
    nixpkgs.overlays = lib.singleton (final: prev: {
      kdePackages = prev.kdePackages // {
        plasma-workspace = let

          # El paquete base que queremos sobrescribir
          basePkg = prev.kdePackages.plasma-workspace;

          # Paquete helper que combina todos los XDG_DATA_DIRS en un solo directorio
          xdgdataPkg = pkgs.stdenv.mkDerivation {
            name = "${basePkg.name}-xdgdata";
            buildInputs = [ basePkg ];
            dontUnpack = true;
            dontFixup = true;
            dontWrapQtApps = true;
            installPhase = ''
              mkdir -p $out/share
              ( IFS=:
                for DIR in $XDG_DATA_DIRS; do
                  if [[ -d "$DIR" ]]; then
                    cp -r $DIR/. $out/share/
                    chmod -R u+w $out/share
                  fi
                done
              )
            '';
          };

          # Deshacer la inyección de XDG_DATA_DIRS que normalmente hace el qt wrapper
          # y en su lugar inyectar la ruta del paquete helper de arriba
          derivedPkg = basePkg.overrideAttrs {
            preFixup = ''
              for index in "''${!qtWrapperArgs[@]}"; do
                if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                  unset -v "qtWrapperArgs[$((index+0))]"
                  unset -v "qtWrapperArgs[$((index+1))]"
                  unset -v "qtWrapperArgs[$((index+2))]"
                  unset -v "qtWrapperArgs[$((index+3))]"
                fi
              done
              qtWrapperArgs=("''${qtWrapperArgs[@]}")
              qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
              qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
            '';
          };

        in derivedPkg;
      };
    });



    # Configuración de Wayland con KDE Plasma 6
    services.desktopManager.plasma6.enable = true;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "breeze";
      settings = {
        General = {
          DisplayServer = "wayland";
        };
      };
    };

    services.displayManager.defaultSession = "plasma";

    # Paquetes extra de KDE Plasma
    environment.systemPackages = with pkgs; [
      kdePackages.konsole
      kdePackages.dolphin
      kdePackages.kate
      kdePackages.gwenview
      kdePackages.spectacle  # Agregar explícitamente
    ];

    # Home Manager con plasma-manager
    home-manager.users.muere = {
      programs.home-manager.enable = true;

      # Habilitar plasma-manager
      programs.plasma = {
        enable = true;

        workspace = {
          lookAndFeel = "org.kde.breezedark.desktop";
        };

        # IMPORTANTE: Deshabilitar los shortcuts por defecto de Spectacle
        spectacle.shortcuts = {
          captureEntireDesktop = "";
          captureRectangularRegion = "Ctrl+Ñ";
          launch = "";
          recordRegion = "";
          recordScreen = "";
          recordWindow = "";
        };

        # Definir los comandos personalizados con hotkeys
        hotkeys.commands = {
#           screenshot-region = {
#             name = "Captura rectangular de pantalla";
#             key = "Ctrl+Ñ";  # o el que prefieras
#             command = "spectacle --region --nonotify";
#           };
          screenshot-fullscreen = {
            name = "Captura pantalla completa";
            key = "Meta+Ctrl+S";
            command = "spectacle --fullscreen --nonotify";
          };
        };

        # Configuración del panel inferior con gestor de tareas
        panels = [
          {
            location = "bottom";
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
                      "applications:firefox.desktop"
                    ];
                  };
                };
              }
              "org.kde.plasma.marginsseparator"
              {
                name = "org.kde.plasma.systemtray";
                config = {
                  General = {
                    shown = [
                      "org.kde.plasma.networkmanagement"
                      "org.kde.plasma.volume"
                    ];
                  };
                };
              }
              {
                name = "org.kde.plasma.digitalclock";
                config = {
                  Appearance = {
                    use24hFormat = "2";
                  };
                };
              }
              "org.kde.plasma.showdesktop"
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
