{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.budgie;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.budgie = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sddm
    ];

    environment.budgie.excludePackages = with pkgs; [
      mate.eom
      mate.pluma
      cinnamon.nemo
    ];

    services = {
      picom.enable = true;
      xserver = {
        enable = true;
        autorun = true;
        displayManager = {
          defaultSession = "budgie-desktop";
          sddm.enable = true;
          sddm.autoNumlock = true;
          sddm.theme = "sddm-sugar-catppuccin-macchiato";
        };
        desktopManager.budgie.enable = true;
        layout = "br";
        xkbVariant = "abnt2";
      };
    };

    # home.configFile = {
    #   "budgie-desktop" = {
    #     source = "${configDir}/budgie-desktop";
    #     recursive = true;
    #   };
    # };
  };
}