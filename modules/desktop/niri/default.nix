{ config, pkgs, lib, inputs, ... }:

let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixi" ];
  userName = "muere";

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Habilitar Niri
    programs.niri.enable = true;

    # Paquetes del sistema necesarios para Niri
    environment.systemPackages = with pkgs; [
      # Noctalia
      inputs.noctalia.packages.${pkgs.system}.default

      # Aplicaciones requeridas por la config
      alacritty   # Terminal (Super+T)
      fuzzel      # App launcher (Super+D)
      swaybg      # Wallpaper

      # Herramientas útiles
      wl-clipboard  # Clipboard para Wayland
      grim          # Screenshots
      slurp         # Selección de región

      # Opcional: para mejor experiencia
      brightnessctl # Control de brillo
      playerctl     # Control de media
    ];

    # Servicios necesarios
    services.gnome.gnome-keyring.enable = true;  # Secret service
    security.polkit.enable = true;

    # Configuración de Home Manager
    home-manager.users.${userName} = { config, ... }: {
      # Importar módulo de Noctalia
      imports = [
        inputs.noctalia.homeModules.default
      ];

      # Habilitar programas necesarios
      programs.alacritty.enable = true;
      programs.fuzzel.enable = true;

      # Polkit para usuario
      services.polkit-gnome.enable = true;

      # Configuración de Noctalia
      programs.noctalia-shell = {
        enable = true;
        settings = {
          bar = {
            position = "top";  # "top", "bottom", "left", "right"
            density = "default";  # "default" o "compact"
            showCapsule = true;
            backgroundOpacity = 1;
            widgets = {
              left = [
                { id = "SystemMonitor"; }
                { id = "ActiveWindow"; }
                { id = "MediaMini"; }
              ];
              center = [
                { id = "Workspace"; }
              ];
              right = [
                { id = "Tray"; }
                { id = "NotificationHistory"; }
                { id = "WiFi"; }
                { id = "Bluetooth"; }
                { id = "Battery"; }
                { id = "Volume"; }
                { id = "Brightness"; }
                { id = "Clock"; }
                { id = "ControlCenter"; }
              ];
            };
          };
          general = {
            avatarImage = "/home/${userName}/.face";  # Opcional: tu avatar
            radiusRatio = 0.2;
            dimDesktop = true;
            showScreenCorners = false;
          };
          location = {
            name = "Buenos Aires";
            useFahrenheit = false;
            use12hourFormat = false;
            showWeekNumberInCalendar = false;
          };
          colorSchemes = {
            predefinedScheme = "Noctalia (default)";  # O "Monochrome", etc.
            darkMode = true;
          };
          appLauncher = {
            position = "center";
            backgroundOpacity = 1;
            sortByMostUsed = true;
          };
          notifications = {
            doNotDisturb = false;
            location = "top_right";
            alwaysOnTop = false;
          };
          audio = {
            volumeStep = 5;
            volumeOverdrive = false;
          };
          brightness = {
            brightnessStep = 5;
          };
        };
      };

      # Configuración de Niri desde archivo
      xdg.configFile."niri/config.kdl".source = ./config.kdl;

      # Variables de sesión para mejor compatibilidad
      home.sessionVariables = {
        # Para aplicaciones Electron
        NIXOS_OZONE_WL = "1";

        # Para algunas aplicaciones Qt
        QT_QPA_PLATFORM = "wayland";

        # Para SDL2
        SDL_VIDEODRIVER = "wayland";
      };

      # Aliases útiles
      programs.bash.shellAliases = {
        niri-reload = "niri msg action reload-config";
        niri-screenshot = "grim -g \"$(slurp)\" - | wl-copy";
        niri-info = "niri msg version";
        noctalia-restart = "systemctl --user restart noctalia-shell";
      };
    };
  };
}
