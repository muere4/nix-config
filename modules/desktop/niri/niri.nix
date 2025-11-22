{ config, pkgs, lib, ... }:

let
  enabledHosts = [ "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Habilitar Niri compositor
    programs.niri.enable = true;

    # Polkit y servicios base
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    # Variables de entorno
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    # Paquetes necesarios para Niri
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      swaybg
      wl-clipboard
      grim
      slurp
      brightnessctl
      playerctl
      pavucontrol
      blueman
      networkmanager
    ];

    # Configuración de Home Manager
    home-manager.users.${userName} = { config, ... }: {
      home.packages = with pkgs; [
        xwayland-satellite
        swaybg
        wl-clipboard
        grim
        slurp
      ];

      services.polkit-gnome.enable = true;

      # Configuración de Niri
      xdg.configFile."niri/config.kdl".source = ./config.kdl;

      # Scripts de Niri
#       xdg.configFile."niri/scripts/load_wallpaper.sh" = {
#         source = ./scripts/load_wallpaper.sh;
#         executable = true;
#       };
#
#       xdg.configFile."niri/scripts/set_wallpaper.sh" = {
#         source = ./scripts/set_wallpaper.sh;
#         executable = true;
#       };
#
#       xdg.configFile."niri/scripts/theme_setter.sh" = {
#         source = ./scripts/theme_setter.sh;
#         executable = true;
#       };
#
#       xdg.configFile."niri/scripts/power-menu.sh" = {
#         source = ./scripts/power-menu.sh;
#         executable = true;
#       };

      # Temas de Niri
#       xdg.configFile."niri/themes/shado.kdl".source = ./themes/shado.kdl;
#       xdg.configFile."niri/themes/gruvbox_dark.kdl".source = ./themes/gruvbox_dark.kdl;
#       xdg.configFile."niri/themes/solar.kdl".source = ./themes/solar.kdl;

      # Crear directorio para capturas
      home.activation.createScreenshotsDir = lib.mkAfter ''
        mkdir -p ~/Pictures/Screenshots
      '';

      # Aliases
      programs.bash.shellAliases = {
        niri-msg = "niri msg";
        niri-reload = "niri msg action reload-config";
        niri-validate = "niri validate";
      };
    };
  };
}
