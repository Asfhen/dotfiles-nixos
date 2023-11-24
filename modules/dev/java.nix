{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.rust;
in {
  options.modules.dev.java = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt true; #devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        openjdk8  # Here for legacy sake
        openjdk17
        maven
        gradle
      ];
    })

    (mkIf cfg.xdg.enable {
      env._JAVA_OPTIONS = "-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME\"/java";
    })
  ];
}