{ config, lib, pkgs, ... }:

let
  enabledHosts = [ "nixi" ];
  isEnabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf isEnabled {
    # Instalar Haruna a nivel sistema
    environment.systemPackages = with pkgs; [
      haruna
    ];

    # Configuración con Home Manager
    home-manager.users.muere = { pkgs, ... }: {
      # Sobreescribir atajos de teclado de Haruna
      xdg.configFile."haruna/shortcuts.conf".text = ''
        [Shortcuts]
        frameStepBackwardAction=U
        frameStepForwardAction=I
      '';
    };
  };
}
