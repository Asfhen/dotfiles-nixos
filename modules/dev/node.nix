{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.node;
in {
  options.modules.dev.node = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt true;
  };

  config = mkMerge [
    (let rtx = pkgs.rtx;
     in mkIf cfg.enable {
      user.packages = [
        rtx
        pkgs.yarn
      ];
    })

    (mkIf cfg.xdg.enable {
      env.NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
      env.NPM_CONFIG_CACHE      = "$XDG_CACHE_HOME/npm";
      env.NPM_CONFIG_TMP        = "$XDG_RUNTIME_DIR/npm";
      env.NPM_CONFIG_PREFIX     = "$XDG_CACHE_HOME/npm";
      env.NODE_REPL_HISTORY     = "$XDG_CACHE_HOME/node/repl_history";

      home.configFile."npm/config".text = ''
        cache=$XDG_CACHE_HOME/npm
        prefix=$XDG_DATA_HOME/npm
      '';
    })
  ];
}