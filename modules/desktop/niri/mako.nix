{ config, pkgs, lib, ... }:

let
  enabledHosts = [ "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    environment.systemPackages = with pkgs; [
      mako
      libnotify
    ];

    home-manager.users.${userName} = {
      services.mako = {
        enable = true;

        # TODAS las opciones ahora van dentro de settings
        settings = {
          # Configuración general
          background-color = "#191724";
          text-color = "#e3c7fc";
          border-color = "#bd93f9";
          border-size = 2;
          border-radius = 12;
          default-timeout = 4000;
          padding = "15";
          width = 350;
          margin = "10";
          font = "JetBrainsMono Nerd Font 11";
          anchor = "top-right";

          # Urgencias
          urgency-low = {
            border-color = "#8897F4";
          };

          urgency-normal = {
            border-color = "#bd93f9";
          };

          urgency-critical = {
            border-color = "#B52A5B";
            default-timeout = 0;
          };
        };
      };
    };
  };
}
