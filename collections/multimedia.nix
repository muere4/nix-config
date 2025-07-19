{utils, pkgs, unstable, ...}:
let
#   libbluray = pkgs.libbluray.override {
#     withAACS = true;
#     withBDplus = true;
#     withJava = true;
#   };
#   vlc = pkgs.vlc.override { inherit libbluray; };
#   whisper-cpp = cudaPkgs.callPackage ./whisper-cpp { nvidia_x11 = cudaPkgs.linuxPackages.nvidia_x11; gcc = cudaPkgs.gcc11; };
in
utils.env.simpleEnvironment {
  packages = with pkgs; [
    unstable.vlc  # Nota: ¡sigue necesitando el prefijo 'unstable'!
    ffmpeg        # Este sí viene de pkgs
    unstable.yt-dlp
  ];

  imports = [];
}
