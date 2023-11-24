{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.game-engines;
in {
  options.modules.desktop.apps.game-engines = {
    enable               = mkBoolOpt false;
    unity3d.enable       = mkBoolOpt false;
    unreal-engine.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      (mkIf cfg.unity3d.enable pkgs.unityhub)
      # (mkIf cfg.unreal-engine.enable unreal-engine)
    ];
  };
}