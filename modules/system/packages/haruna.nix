{ pkgs, lib, ... }:

let
  users = [ "muere" ];
in
{
  # ─── Sistema ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    haruna
  ];

  # ─── Home Manager ──────────────────────────────────────────
  home-manager.users = lib.genAttrs users (_: {
    xdg.configFile."haruna/shortcuts.conf".text = ''
      [Shortcuts]
      frameStepBackwardAction=U
      frameStepForwardAction=I
    '';
  });
}
