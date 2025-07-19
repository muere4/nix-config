{ config, pkgs, inputs, system, unstable, ... }:

let
  load     = f: import f { inherit pkgs utils; };
  utils    = import ./utils;
in
import ./generic.nix
  { desktopEnvironment = "plasma";
    platform = "x86-64";
    # Usa importOnlyEnvironment para convertir el módulo en entorno válido
    extraEnvironments = [
      (utils.env.importOnlyEnvironment (load ./configs/kitty.nix))
    ];
    extraPackages = [
    pkgs.gparted
    pkgs.libreoffice
    ];
     developmentEnvironmentArgs = {
       haskell-formatter-package = ./development-environment/haskell/formatter/fourmolu.nix;
     };
    inherit config pkgs inputs system unstable;
  }
