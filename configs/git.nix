# configs/git.nix
{...}:
{
  programs.git = {
    enable = true;
    userName = "muere4";
    userEmail = "muere4@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "kate";
      color.ui = "auto";
    };
  };
}

