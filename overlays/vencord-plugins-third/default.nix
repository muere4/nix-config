# default.nix
{ pkgs ? import <nixpkgs> {}
, lib ? pkgs.lib
, fetchFromGitHub ? pkgs.fetchFromGitHub
}:

let
  messageLoggerEnhanced = fetchFromGitHub {
    owner = "Syncxv";
    repo = "vc-message-logger-enhanced";
    rev = "master";
    sha256 = "sha256-IomN3bCGQOTm9Q1QSrEGTwU+MnjdY3GsucBN9zczb2s=";  # Esto generará el hash correcto en el error
  };

  vencordWithPlugins = pkgs.vencord.overrideAttrs (oldAttrs: {
    postPatch = oldAttrs.postPatch or "" + ''
      mkdir -p src/userplugins
      cp -r ${messageLoggerEnhanced} src/userplugins/vc-message-logger-enhanced
    '';
  });
in
pkgs.discord.override {
  withVencord = true;
  vencord = vencordWithPlugins;
}
