{ pkgs
, utils
, extraLibs ? []
, haskellVersion ? null
, formatter ? null
, ...}:

let
  haskell = if builtins.isNull haskellVersion
            then pkgs.haskellPackages
            else
              let versionStr = builtins.toString haskellVersion;
              in pkgs.haskell.packages."ghc${versionStr}";

  ghciConfig = import ./settings/ghci;

  devPackages = haskell.ghcWithPackages(hsPkgs:
    let
      buildTools =
        with hsPkgs;
        [ cabal-install
          cabal2nix
          haskell-language-server  # LSP server para Neovim
        ];
      devTools =
        with hsPkgs;
        [ hoogle
          hasktags
          hlint
        ];
      basicLibraries =
        with hsPkgs;
        [ bytestring
          text
          vector
          time
          unix
          mtl
          transformers
          array
          deepseq
          filepath
          process
          primitive
          stm
          aeson ];
    in builtins.concatLists [buildTools devTools basicLibraries extraLibs]
  );

  formatterEnvironment =
    let
      formatterPackage = import formatter { haskellPackages = haskell; };

      # Configuración de Emacs comentada - mantenida para referencia
      # emacsFormatter = ''
      #   (defun haskell-formatter-path ()
      #     "Return the path to the binary that should be called for format programs."
      #     "${formatterPackage.exec}"
      #   );
      # '';
    in
      { packages = [ formatterPackage.package ];
        imports = [ formatterPackage.config ];

        # Configuración comentada de Emacs
        # emacsFormatterFunction = emacsFormatter;
        # emacsExtraConfig = emacsFormatter;

        # La configuración del formatter para Neovim se maneja en nvim
        formatterPath = formatterPackage.exec;
      };

  devEnvironment =
    { packages = [ devPackages ];
      imports = [ ghciConfig ];

      # Configuración de Emacs comentada - mantenida para referencia
      # emacsExtraPackages = epkgs:
      #   with epkgs; [
      #     hasklig-mode
      #     haskell-mode
      #     nix-haskell-mode
      #   ];
    };

  pkg =
    if builtins.isNull formatter
    then devEnvironment
    else utils.env.mergeEnvironments devEnvironment formatterEnvironment;

in pkg
