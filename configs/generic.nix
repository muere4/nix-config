{ pkgs, unstable, utils, inputs, system, ...}:
let
  #funcionacfg = p: utils.env.configOnlyEnvironment (import p { inherit pkgs unstable utils inputs system; });
   cfg = p: utils.env.configOnlyEnvironment (import p {});
  #cfg = p: utils.env.configOnlyEnvironment (import p);

  mkConfigs = cfgPaths: utils.env.concatEnvironments (builtins.map cfg cfgPaths);

  generalConfigs = mkConfigs [
    ./bash.nix
    ./direnv.nix
    ./git.nix
  ];

in utils.env.concatEnvironments [generalConfigs ]
