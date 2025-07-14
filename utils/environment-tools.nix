# utils/environment-tools.nix
rec {
  mergeEnvironments = aPartial: bPartial:
    let
      a = unpartialEnvironment aPartial;
      b = unpartialEnvironment bPartial;
    in {
      packages           = a.packages ++ b.packages;
      imports            = a.imports ++ b.imports;
      emacsExtraPackages = epkgs: (a.emacsExtraPackages epkgs) ++ (b.emacsExtraPackages epkgs);
      emacsExtraConfig   = a.emacsExtraConfig + b.emacsExtraConfig;
    };

  emptyEnvironment = {
    packages           = [];
    imports            = [];
    emacsExtraPackages = _ : [];
    emacsExtraConfig   = "";
  };

  unpartialEnvironment = pe: emptyEnvironment // pe;
  concatEnvironments   = builtins.foldl' mergeEnvironments emptyEnvironment;

  simpleEnvironment = args@{ packages, imports }: args // {
    emacsExtraPackages = _ : [];
    emacsExtraConfig   = "";
  };

  packagesEnvironment     = pkgsList: simpleEnvironment { inherit pkgsList; imports = []; packages = pkgsList; };
  packageEnvironment      = pkg: simpleEnvironment { packages = [ pkg ]; imports = []; };
  importsEnvironment      = importsList: simpleEnvironment { packages = []; imports = importsList; };
  importOnlyEnvironment   = imp: simpleEnvironment { packages = []; imports = [ imp ]; };
  configOnlyEnvironment   = cfgVal: importOnlyEnvironment (x: cfgVal);
}
