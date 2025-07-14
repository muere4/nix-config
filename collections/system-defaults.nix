{ platform ? "x86-64", utils, pkgs, unstable, ...}:
let
  globalDefaults = utils.env.concatEnvironments [
    (import ./command-line-env.nix { inherit pkgs utils; })
    (import ./multimedia.nix { inherit pkgs utils; })
  ];

  x86-64-pkgs = utils.env.concatEnvironments [
    globalDefaults
    # Aquí puedes agregar paquetes específicos para x86-64
  ];

  platformMap = {
    x86-64 = x86-64-pkgs;
    arm64 = globalDefaults;
  };
in platformMap.${platform}
