{ config, pkgs, lib, ... }:

let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixi" ];  # [ "nixi" ] cuando quieras habilitarlo
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
      # Aplicaciones requeridas por la config por defecto
      alacritty   # Terminal (Super+T)
      fuzzel      # App launcher (Super+D)
      waybar      # Barra de estado
      swaylock    # Lock screen (Super+Alt+L)
      swaybg      # Wallpaper
      mako        # Notificaciones

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
    security.pam.services.swaylock = {};  # Para swaylock

    # Configuración de Home Manager
    home-manager.users.${userName} = { config, ... }: {
      # Habilitar programas necesarios
      programs.alacritty.enable = true;
      programs.fuzzel.enable = true;
      programs.swaylock.enable = true;
      programs.waybar.enable = true;

      services.mako.enable = true;
      services.swayidle.enable = true;

      # Polkit para usuario
      services.polkit-gnome.enable = true;

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
      };
    };
  };
}
