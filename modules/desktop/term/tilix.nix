{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.tilix;
in {
  options.modules.desktop.term.tilix = {
    enable = mkBoolOpt false;
    theme  = mkOpt types.str "catppuccin-macchiato"; # TODO: add automatic theming for tilix
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      tilix
    ];
  };
}