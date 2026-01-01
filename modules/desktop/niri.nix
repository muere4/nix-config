{ config, pkgs, lib, ... }:
let
  enabledHosts = [ "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Sistema
    programs.niri = {
      enable = true;
      package = pkgs.unstable.niri;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    networking.networkmanager.enable = true;
    services.upower.enable = true;
    security.polkit.enable = true;

    # Usuario
    home-manager.users.${userName} = {
      programs.dankMaterialShell = {
        enable = true;
        systemd.enable = true;  # Auto-inicia DMS con systemd

        enableSystemMonitoring = true;
        enableClipboard = true;
        enableDynamicTheming = true;
        enableAudioWavelength = true;

        default.settings = {
          theme = "dark";
          dynamicTheming = true;
        };
      };

      home.packages = with pkgs; [
        alacritty
        kdePackages.kate
        kdePackages.dolphin
        kdePackages.okular
        xwayland-satellite
      ];
    };
  };
}
