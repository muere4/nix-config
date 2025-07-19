{ pkgs
, utils
, haskell-formatter-package ? null
, haskellVersion ? null
, enableDotnet ? true
, dotnetWorkloads ? true
, ...
}:
utils.env.concatEnvironments [
  (import ./haskell { inherit pkgs utils haskellVersion; formatter = haskell-formatter-package;})
  (import ./rust {inherit pkgs utils;})
  (import ./gcc {inherit pkgs utils;})
  (import ./global-dev-env {inherit pkgs utils;})
  # Agregar soporte para .NET
  (if enableDotnet then
    (import ./dotnet {inherit pkgs utils; enableWorkloads = dotnetWorkloads;})
   else {})
  # (import ./nixdev {inherit pkgs utils;})
  #(import ./vscode.nix {inherit pkgs utils;})
  (import ./nvim {inherit pkgs utils;})
]
