{ pkgs, unstable, utils, inputs, system, ...}:
let
  cfg = p: utils.env.configOnlyEnvironment (import p { inherit pkgs unstable utils inputs system; });
  mkConfigs = cfgPaths: utils.env.concatEnvironments (builtins.map cfg cfgPaths);

  generalConfigs = mkConfigs [
    ./bash.nix
    ./direnv.nix
    ./git.nix
  ];

in utils.env.concatEnvironments [generalConfigs ]
