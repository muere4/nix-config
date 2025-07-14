# configs/bash.nix
{...}:
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -la";
      la = "ls -la";
      ".." = "cd ..";
      "..." = "cd ../..";
    };
    bashrcExtra = ''
      # Configuración adicional de bash
      export PS1="\u@\h:\w $ "
    '';
  };
}

