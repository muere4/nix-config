{ config, pkgs, lib, ... }:

let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixos" "nixi" ];
  userName = "muere";

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    home-manager.users.${userName} = {
      programs.git = {
        enable = true;

        # Configuración global por defecto (muere4 - cuenta principal)
        userName = "muere4";
        userEmail = "muere4@gmail.com";

        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = true;
          core.editor = "kate";
        };

        # Configuración condicional por directorio usando includes
        includes = [
          {
            condition = "gitdir:~/facusmzi/";
            contents = {
              user = {
                name = "facusmzi";
                email = "facusmzi@gmail.com";
              };
              core = {
                sshCommand = "ssh -i ~/.ssh/github_facusmzi -F /dev/null";
              };
            };
          }
        ];

        aliases = {
          st = "status";
          co = "checkout";
          br = "branch";
          ci = "commit";
          unstage = "reset HEAD --";
          last = "log -1 HEAD";
          lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
          whoami = "!echo \"User: $(git config user.name) <$(git config user.email)>\" && echo \"SSH: $(git config core.sshCommand || echo 'default')\"";
        };

        # Ignores globales
        ignores = [
          "*~"
          "*.swp"
          "*.swo"
          ".DS_Store"
          "Thumbs.db"
          ".idea/"
          ".vscode/"
          "*.log"
        ];
      };
    };

    # Git a nivel sistema
    environment.systemPackages = with pkgs; [
      git
      git-lfs
      gh
    ];
  };
}
