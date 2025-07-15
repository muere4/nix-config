{ pkgs
, utils
, ...
}:
let
  cfg = p: utils.env.configOnlyEnvironment (import p);
  mkConfigs = cfgPaths: utils.env.concatEnvironments (builtins.map cfg cfgPaths);

  mkImport = p: utils.env.importOnlyEnvironment (import p);
  mkImports = importPaths: utils.env.concatEnvironments (builtins.map mkImport importPaths);

  plasmaGeneralEnv =
    mkConfigs [
                ./mimeApps.nix
              ];


  plasmaPackages = utils.env.packagesEnvironment (with pkgs; [  ]);

in utils.env.concatEnvironments [ plasmaGeneralEnv plasmaPackages]
