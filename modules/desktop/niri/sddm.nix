{ config, pkgs, lib, ... }:

let
  enabledHosts = [ "nixi" ];
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "breeze";
    };

    services.displayManager.defaultSession = "niri";
  };
}
