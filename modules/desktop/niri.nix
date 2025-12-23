{ config, pkgs, lib, inputs, ... }:

let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixi" ];  # Hosts donde se habilita Niri + Noctalia
  userName = "muere";

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {

    # ========================================
    # NIRI COMPOSITOR
    # ========================================

    programs.niri.enable = true;

    # Variable para apps Electron/Chromium en Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # ========================================
    # SERVICIOS REQUERIDOS
    # ========================================

    # Servicios necesarios para Noctalia
    networking.networkmanager.enable = true;  # WiFi en Noctalia
    hardware.bluetooth.enable = true;         # Bluetooth en Noctalia
    services.power-profiles-daemon.enable = true;  # Power profiles
    services.upower.enable = true;            # Battery info

    # Servicios adicionales recomendados para Niri
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.swaylock = {};

    # Evolution Data Server para calendario (opcional)
    services.gnome.evolution-data-server.enable = true;

    # Variables para calendar events
    environment.sessionVariables = {
      GI_TYPELIB_PATH = lib.makeSearchPath "lib/girepository-1.0" (
        with pkgs; [
          evolution-data-server
          libical
          glib.out
          libsoup_3
          json-glib
          gobject-introspection
        ]
      );
    };

    # ========================================
    # PAQUETES DEL SISTEMA
    # ========================================

    environment.systemPackages = with pkgs; [
      # Soporte XWayland (muy recomendado)
      xwayland-satellite

      # Herramientas básicas para Niri
      alacritty      # Terminal (Super+T)
      fuzzel         # Launcher (Super+D por defecto en Niri, pero Noctalia tiene el suyo)
      swaylock       # Screen locker
      mako           # Notificaciones (Noctalia tiene las suyas también)
      swayidle       # Idle management
      swaybg         # Wallpapers (Noctalia tiene su propio manager)

      # Dependencias para Noctalia calendar
      (python3.withPackages (pyPkgs: with pyPkgs; [ pygobject3 ]))

      # Utilidades
      wl-clipboard
      grim           # Screenshots
      slurp          # Region selection
    ];

    # ========================================
    # HOME MANAGER - NIRI CONFIGURATION
    # ========================================

    home-manager.users.${userName} = { config, pkgs, ... }: {

      # Configuración de Niri
      xdg.configFile."niri/config.kdl".text = ''
        input {
            keyboard {
                xkb {
                    layout "es"
                }
            }

            touchpad {
                tap
                natural-scroll
                dwt
            }

            mouse {
                accel-speed 0.2
            }
        }

        output "eDP-1" {
            mode "1920x1080@60"
            scale 1.0
        }

        layout {
            gaps 8
            center-focused-column "never"

            preset-column-widths {
                proportion 0.33333
                proportion 0.5
                proportion 0.66667
            }

            default-column-width { proportion 0.5; }

            focus-ring {
                width 2
                active-color 170 170 255 255
                inactive-color 80 80 80 255
            }

            border {
                width 1
                active-color 255 255 255 255
                inactive-color 64 64 64 255
            }
        }

        prefer-no-csd

        screenshot-path "~/Pictures/Screenshots/screenshot-%Y-%m-%d_%H-%M-%S.png"

        binds {
            Mod+Space { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
            Mod+Shift+Space { spawn "noctalia-shell" "ipc" "call" "controlCenter" "toggle"; }
            Mod+N { spawn "noctalia-shell" "ipc" "call" "notificationPanel" "toggle"; }
            Mod+L { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }
            Mod+Shift+Q { spawn "noctalia-shell" "ipc" "call" "sessionMenu" "toggle"; }
            Mod+M { maximize-column; }

            Mod+Return { spawn "alacritty"; }
            Mod+D { spawn "fuzzel"; }

            Mod+Q { close-window; }

            Mod+Left  { focus-column-left; }
            Mod+Down  { focus-window-down; }
            Mod+Up    { focus-window-up; }
            Mod+Right { focus-column-right; }
            Mod+H     { focus-column-left; }
            Mod+J     { focus-window-down; }
            Mod+K     { focus-window-up; }
            Mod+Semicolon { focus-column-right; }

            Mod+Shift+Left  { move-column-left; }
            Mod+Shift+Down  { move-window-down; }
            Mod+Shift+Up    { move-window-up; }
            Mod+Shift+Right { move-column-right; }
            Mod+Shift+H     { move-column-left; }
            Mod+Shift+J     { move-window-down; }
            Mod+Shift+K     { move-window-up; }
            Mod+Shift+Colon { move-column-right; }

            Mod+1 { focus-workspace 1; }
            Mod+2 { focus-workspace 2; }
            Mod+3 { focus-workspace 3; }
            Mod+4 { focus-workspace 4; }
            Mod+5 { focus-workspace 5; }

            Mod+Shift+1 { move-column-to-workspace 1; }
            Mod+Shift+2 { move-column-to-workspace 2; }
            Mod+Shift+3 { move-column-to-workspace 3; }
            Mod+Shift+4 { move-column-to-workspace 4; }
            Mod+Shift+5 { move-column-to-workspace 5; }

            Mod+Minus { set-column-width "-10%"; }
            Mod+Equal { set-column-width "+10%"; }
            Mod+Shift+Minus { set-window-height "-10%"; }
            Mod+Shift+Equal { set-window-height "+10%"; }

            Mod+F { fullscreen-window; }

            Print { screenshot; }
            Ctrl+Print { screenshot-screen; }
            Alt+Print { screenshot-window; }

            XF86AudioRaiseVolume { spawn "noctalia-shell" "ipc" "call" "volume" "increase"; }
            XF86AudioLowerVolume { spawn "noctalia-shell" "ipc" "call" "volume" "decrease"; }
            XF86AudioMute { spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput"; }
            XF86AudioMicMute { spawn "noctalia-shell" "ipc" "call" "volume" "muteInput"; }

            XF86MonBrightnessUp { spawn "noctalia-shell" "ipc" "call" "brightness" "increase"; }
            XF86MonBrightnessDown { spawn "noctalia-shell" "ipc" "call" "brightness" "decrease"; }

            Mod+Shift+E { quit; }
        }

        spawn-at-startup "noctalia-shell"
      '';

      # Habilitar programas básicos
      programs.alacritty.enable = true;
      programs.fuzzel.enable = true;
      programs.swaylock.enable = true;

      services.mako.enable = true;
      services.swayidle.enable = true;

      # ========================================
      # NOCTALIA CONFIGURATION
      # ========================================

      programs.noctalia-shell = {
        enable = true;

        settings = {
          bar = {
            position = "top";
            density = "default";
            transparent = false;
            showCapsule = true;
            widgets = {
              left = [
                {
                  id = "ControlCenter";
                  useDistroLogo = true;
                }
                { id = "Clock"; }
                { id = "ActiveWindow"; }
              ];
              center = [
                {
                  id = "Workspace";
                  hideUnoccupied = false;
                  labelMode = "none";
                }
              ];
              right = [
                { id = "SystemMonitor"; }
                { id = "Tray"; }
                { id = "NotificationHistory"; }
                { id = "WiFi"; }
                { id = "Bluetooth"; }
                { id = "Battery"; }
                { id = "Volume"; }
              ];
            };
          };

          general = {
            avatarImage = "/home/${userName}/.face";
            radiusRatio = 0.2;
            lockOnSuspend = true;
          };

          location = {
            name = "Buenos Aires, Argentina";
            monthBeforeDay = false;  # DD/MM/YYYY formato argentino
            weatherEnabled = true;
          };

          appLauncher = {
            position = "center";
            terminalCommand = "alacritty -e";
          };

          colorSchemes = {
            predefinedScheme = "Monochrome";  # o "Noctalia (default)"
            darkMode = true;
          };

          dock = {
            enabled = true;
            displayMode = "auto_hide";
            pinnedApps = [
              "alacritty"
              "org.kde.dolphin"
              "microsoft-edge"
            ];
          };

          # Habilitar templates para otras apps
          templates = {
            gtk = true;
            qt = true;
            kitty = false;
            alacritty = true;
          };
        };
      };

      # Asociaciones de archivos para apps en Niri
#       xdg.mimeApps.defaultApplications = {
#         "text/html" = [ "microsoft-edge.desktop" ];
#         "x-scheme-handler/http" = [ "microsoft-edge.desktop" ];
#         "x-scheme-handler/https" = [ "microsoft-edge.desktop" ];
#         "inode/directory" = [ "org.kde.dolphin.desktop" ];
#       };
    };
  };
}
