{
  programs.git = {
    enable = true;
    userEmail = "muere4@gmail.com";
    userName = "muere4";
    aliases = {
      co = "checkout";
      br = "!git --no-pager branch";
      ff = "merge --ff-only";
      what-changed = "!git --no-pager diff --name-only";
      st = "status";
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      github = {
        user = "muere4";
      };
    };
  };
}
