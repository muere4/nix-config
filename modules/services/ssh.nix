{ config, pkgs, lib, ... }:

let
  # Hosts en los que este módulo estará habilitado
  enabledHosts = [ "nixos" "nixi" ];
  userName = "muere";

  # Detectar si este host está habilitado
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Cliente SSH del sistema (arranca el agente)
    #programs.ssh.startAgent = true;

    # Configuración de Home Manager para el usuario
    home-manager.users.${userName} = { ... }: {
      # Asegurarse de tener ssh-keygen disponible
      home.packages = [ pkgs.openssh ];

      programs.ssh = {
        enable = true;
        extraConfig = ''
          AddKeysToAgent yes
        '';
        matchBlocks = {
          # GitHub - Cuenta principal (muere4)
          "github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = "~/.ssh/github_muere4";
            identitiesOnly = true;
          };

          # GitHub - Cuenta secundaria (facusmzi)
          "github.com-facusmzi" = {
            hostname = "github.com";
            user = "git";
            identityFile = "~/.ssh/github_facusmzi";
            identitiesOnly = true;
          };
        };
      };

      # Script de activación para generar claves si no existen
      home.activation.generateSshKeys = lib.mkAfter ''
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh

        if [ ! -f ~/.ssh/github_muere4 ]; then
          ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f ~/.ssh/github_muere4 -N "" -C "muere4@gmail.com"
        fi

        if [ ! -f ~/.ssh/github_facusmzi ]; then
          ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -f ~/.ssh/github_facusmzi -N "" -C "facusmzi@gmail.com"
        fi

        chmod 600 ~/.ssh/github_muere4 ~/.ssh/github_facusmzi
        chmod 644 ~/.ssh/github_muere4.pub ~/.ssh/github_facusmzi.pub
      '';

      # Config de SSH declarativa
      home.file.".ssh/config".text = ''
        Host github.com
          HostName github.com
          User git
          IdentityFile ~/.ssh/github_muere4
          IdentitiesOnly yes

        Host github.com-facusmzi
          HostName github.com
          User git
          IdentityFile ~/.ssh/github_facusmzi
          IdentitiesOnly yes
      '';
    };
  };
}
