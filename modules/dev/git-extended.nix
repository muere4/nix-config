{ config, pkgs, lib, ... }:

let
  enabledHosts = [ "nixos" "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    home-manager.users.${userName} = {
      programs.git = {
        enable = true;

        # Nueva sintaxis para 25.11
        settings = {
          user = {
            name = "muere4";
            email = "muere4@gmail.com";
          };

          init.defaultBranch = "main";
          pull.rebase = true;
          core.editor = "kate";

          # Aliases ahora van dentro de settings
          alias = {
            st = "status";
            co = "checkout";
            br = "branch";
            ci = "commit";
            unstage = "reset HEAD --";
            last = "log -1 HEAD";
            lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
            whoami = "!echo \"User: $(git config user.name) <$(git config user.email)>\" && echo \"SSH: $(git config core.sshCommand || echo 'default')\"";
          };
        };

        # Configuración condicional por directorio
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

    environment.systemPackages = with pkgs; [
      git
      git-lfs
      gh
    ];
  };
}
