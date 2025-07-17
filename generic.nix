{ config
, pkgs
, unstable ? pkgs
, desktopEnvironment # should be one of "kde" or "xmonad"
, platform # should be one of "x86-64" or "arm64"
, inputs
, system
, haskellVersion ? null
, extraImports  ? []
, extraPackages ? []
, extraEnvironments ? []
, developmentEnvironmentArgs ? {}
}:

let
  utils = import ./utils;
  environment =
    let
      usrEnvs = utils.env.concatEnvironments extraEnvironments;
      envPackages = import ./collections/system-defaults.nix {inherit pkgs unstable utils platform; };
      #devEnvironment = import ./development-environment ({ inherit pkgs utils haskellVersion; } // developmentEnvironmentArgs);
      de = import ./desktop-environment/config.nix { inherit pkgs utils desktopEnvironment; };
      defaultEnvironment = import ./configs/generic.nix { inherit pkgs unstable utils inputs system; };
      e = utils.env.concatEnvironments [ de defaultEnvironment envPackages ];
#       emacsEnvironment = import ./emacs { inherit pkgs utils;
#                                           extraPackages = e.emacsExtraPackages;
#                                           extraConfigs = [e.emacsExtraConfig];
#                                         };
      vscodeEnvironment = import ./vscode { inherit pkgs utils;
                                     userDefinedExtensions = e.vscodeExtraExtensions or (vscode-extensions: []);
                                     extraSettings = e.vscodeExtraSettings or {};
                                   };

    in utils.env.concatEnvironments [e vscodeEnvironment usrEnvs];
  homeConfig =
    {
      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      #home.sessionVariables = { GTK_THEME = "Adwaita:dark"; };

      # Home Manager needs a bit of information about you and the
      # paths it should manage.
      home.username = "muere";
      home.homeDirectory = "/home/muere";
      imports = environment.imports ++ extraImports;
      home.packages = environment.packages ++ extraPackages;

      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      home.stateVersion = "25.05";
    };
in homeConfig
