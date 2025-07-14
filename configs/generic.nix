{ pkgs, utils, inputs, system, ...}:
let
  cfg = p: utils.env.configOnlyEnvironment (import p);
  mkConfigs = cfgPaths: utils.env.concatEnvironments (builtins.map cfg cfgPaths);

  generalConfigs = mkConfigs [
    ./bash.nix
    ./direnv.nix
    ./git.nix
  ];

in generalConfigs
