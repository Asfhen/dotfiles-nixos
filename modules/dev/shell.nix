{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.shell;
in {
  options.modules.dev.shell = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt true; #devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        shellcheck
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}