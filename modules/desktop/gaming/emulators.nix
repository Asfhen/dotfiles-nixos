{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.emulators;
in {
  options.modules.desktop.gaming.emulators = {
    psx.enable       = mkBoolOpt false;  # Playstation
    ds.enable        = mkBoolOpt false;  # Nintendo DS
    gb.enable        = mkBoolOpt false;  # GameBoy + GameBoy Color
    gba.enable       = mkBoolOpt false;  # GameBoy Advance
    snes.enable      = mkBoolOpt false;  # Super Nintendo
    retroarch.enable = mkBoolOpt false;  # Retro Arch
  };

  config = {
    user.packages = with pkgs; [
      (mkIf cfg.ds.enable desmume)
      (mkIf (cfg.gba.enable ||
             cfg.gb.enable  ||
             cfg.snes.enable)
        higan)
      (mkIf cfg.retroarch.enable retroarch)
    ];
  };
}