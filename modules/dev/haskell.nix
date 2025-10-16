{ config, pkgs, lib, ... }:

let
  # Configuración del módulo
  enabledHosts = [ "nixi" ];
  userName = "muere";

  # Versión de GHC (null = usar default, o especificar como 98, 910, etc.)
  haskellVersion = null; # GHC 9.8.x - Cambia esto para usar otra versión

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;

  # Seleccionar el paquete de Haskell según la versión
  haskell = if builtins.isNull haskellVersion
            then pkgs.haskellPackages
            else
              let versionStr = builtins.toString haskellVersion;
              in pkgs.haskell.packages."ghc${versionStr}";

  # Haskell con paquetes básicos
  haskellEnv = haskell.ghcWithPackages (hpkgs: with hpkgs; [
    # Build tools
    cabal-install

    # Librerías básicas (como Rebecca)
    base
    aeson
    text
    postgresql-simple
    bytestring
    containers
    mtl
    transformers
    vector
    unordered-containers
    time
    unix
    array
    deepseq
    filepath
    process
    primitive
    stm

    # Testing
    hspec
    QuickCheck
    tasty
    tasty-hunit

    # Utilidades
    lens
    optparse-applicative
  ]);

in
{
  config = lib.mkIf enabled {
    # Paquetes a nivel de sistema
    environment.systemPackages = with pkgs; [
      # Haskell toolchain
      haskellEnv

      # LSP y herramientas de desarrollo
      haskell-language-server
       haskell.fourmolu
      haskell.hlint
      haskell.hoogle
      haskell.hasktags
      haskell.ghcid
    ];

    # Configuración de Home Manager
    home-manager.users.${userName} = { config, ... }: {
      # Paquetes específicos del usuario
      home.packages = with pkgs; [
        haskellEnv
        haskell-language-server
        haskell.fourmolu
        haskell.hlint
        haskell.hoogle
        haskell.hasktags
        haskell.ghcid
      ];

      # Configuración de GHCi
      home.file.".ghci".text = ''
        :set prompt "λ "
        :set prompt-cont "| "

        -- Extensions útiles
        :set -XOverloadedStrings
        :set -XRankNTypes
        :set -XTypeApplications
        :set -XDataKinds
        :set -XTupleSections
        :set -XGADTs
        :set -XLambdaCase
        :set -XDerivingStrategies

        -- Colores
        :set -fdiagnostics-color=always

        -- Importaciones comunes
        import qualified Data.Text as T
        import qualified Data.Text.IO as TIO
        import qualified Data.ByteString as BS
        import qualified Data.Map as M
        import qualified Data.Set as S
      '';


      # Configuración de Fourmolu (formatter)
      home.file.".fourmolu.yaml".text = ''
        indentation: 2
        comma-style: leading
        record-brace-space: false
        indent-wheres: true
        respectful: true
        haddock-style: multi-line
        newlines-between-decls: 1
      '';

      # Variables de entorno
      home.sessionVariables = {
        # Para que HLS encuentre el GHC correcto
        HASKELL_LANGUAGE_SERVER_WRAPPER = "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper";
      };

      # Aliases útiles para Haskell
      programs.bash.shellAliases = {
        # GHC y GHCi
        ghci = "ghci -fobject-code";
        ghc-pkg-list = "ghc-pkg list";

        # Cabal
        cab = "cabal";
        cabb = "cabal build";
        cabr = "cabal run";
        cabt = "cabal test";
        cabi = "cabal install";
        cabn = "cabal new-build";
        cabc = "cabal clean";

        # Herramientas
        hlint-all = "hlint .";
        hoogle-server = "hoogle server --local -p 8080";
        ghcid-run = "ghcid --command='cabal repl'";

        # Fourmolu
        fmt = "fourmolu -i";
        fmt-all = "find . -name '*.hs' -exec fourmolu -i {} \\;";
      };

      programs.zsh.shellAliases = {
        # GHC y GHCi
        ghci = "ghci -fobject-code";
        ghc-pkg-list = "ghc-pkg list";

        # Cabal
        cab = "cabal";
        cabb = "cabal build";
        cabr = "cabal run";
        cabt = "cabal test";
        cabi = "cabal install";
        cabn = "cabal new-build";
        cabc = "cabal clean";


        # Herramientas
        hlint-all = "hlint .";
        hoogle-server = "hoogle server --local -p 8080";
        ghcid-run = "ghcid --command='cabal repl'";

        # Fourmolu
        fmt = "fourmolu -i";
        fmt-all = "find . -name '*.hs' -exec fourmolu -i {} \\;";
      };

      # Script de activación para generar la base de datos de Hoogle
#       home.activation.generateHoogleDatabase = lib.mkAfter ''
#         if ! [ -f ~/.hoogle/default.hoo ]; then
#           echo "📚 Generando base de datos de Hoogle..."
#           mkdir -p ~/.hoogle
#           ${haskell.hoogle}/bin/hoogle generate
#         fi
#       '';
    };
  };
}
