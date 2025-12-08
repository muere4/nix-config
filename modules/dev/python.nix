{ config, pkgs, lib, ... }:

let
  enabledHosts = [ "nixi" ];
  userName = "muere";
  enabled = builtins.elem config.networking.hostName enabledHosts;

  # Python personalizado con paquetes
  pythonWithPackages = pkgs.python312.withPackages (ps: with ps; [
    pip
    virtualenv
    # Data Science
    numpy
    pandas
    matplotlib
    scipy
    scikit-learn
    # Web
    requests
    flask
    django
    # Utilidades
    black
    pylint
    pytest
    ipython
  ]);

in
{
  config = lib.mkIf enabled {
    # Python a nivel sistema
    environment.systemPackages = with pkgs; [
      pythonWithPackages
      pyright
      python312Packages.python-lsp-server
      poetry
    ];

    # Configuración de Home Manager
    home-manager.users.${userName} = { config, ... }: {
      home.packages = with pkgs; [
        pythonWithPackages
        pyright
        python312Packages.python-lsp-server
      ];

      # Aliases útiles
      programs.bash.shellAliases = {
        py = "python";
        ipy = "ipython";
        pyfmt = "black .";
        pylint-all = "pylint **/*.py";
        pytest-watch = "pytest --watch";
        venv-create = "python -m venv venv";
        venv-activate = "source venv/bin/activate";
      };

      # Variables de entorno
      home.sessionVariables = {
        PYTHONPATH = "${pythonWithPackages}/${pythonWithPackages.sitePackages}";
      };
    };
  };
}
