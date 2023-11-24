{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.daw;
in {
  options.modules.desktop.media.daw = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.ardour  # recording, mixing, loops
      lmms             # for making music
      unstable.sunvox  # my favorite midi tracker
      audacity         # for recording and remastering audio
    ];
  };
}