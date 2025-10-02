{ config, pkgs, lib, ... }:

let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixos" "nixi" ];  # Lista de hosts donde se habilita
  userName = "muere4";
  userEmail = "muere4@gmail.com";
  
  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    home-manager.users.muere = {
      programs.git = {
        enable = true;
        userName = userName;
        userEmail = userEmail;
        
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = true;
          core.editor = "kate";
        };
        
        aliases = {
          st = "status";
          co = "checkout";
          br = "branch";
          ci = "commit";
          unstage = "reset HEAD --";
          last = "log -1 HEAD";
        };
      };
    };
    
    # Git stable del sistema
    environment.systemPackages = with pkgs; [
      git
      git-lfs
      # Si quisieras git de unstable sería: unstable.git
    ];
  };
}
