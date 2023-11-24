{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.lua;
in {
  options.modules.dev.lua = {
    enable = mkBoolOpt false;
    # xdg.enable = mkBoolOpt devCfg.enableXDG;
    love2D.enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        lua
        luaPackages.moonscript
        (mkIf cfg.love2D.enable love2d)
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}