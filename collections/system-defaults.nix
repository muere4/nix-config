{ platform, utils, pkgs, unstable, ...}:
let
  globalDefaults = utils.env.concatEnvironments [
    (import ./command-line-env.nix { inherit pkgs utils; })
  ];

  x86-64-pkgs = utils.env.concatEnvironments [
    (import ./multimedia.nix { inherit utils pkgs unstable; })
  ];

  platformMap =
    { x86-64 = utils.env.mergeEnvironments x86-64-pkgs globalDefaults;
      arm64 = globalDefaults;
    };
in platformMap.${platform}
