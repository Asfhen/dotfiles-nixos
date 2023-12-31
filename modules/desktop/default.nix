{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in {
  config = mkIf config.services.xserver.enable {
    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message = "Can't have more than one environment variable at a time.";
      }
      {
        assertion =
          let srv = config.services;
          in srv.xserver.enable ||
             srv.sway.enable ||
             !(anyAttrs
                (n: v: isAttrs v &&
                       anyAttrs (n: v: isAttrs v && v.enable))
                cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    user.packages = with pkgs; [
      gnome-photos
      xclip
      xdotool
      xorg.xwininfo
      libqalculate
      # qgnomeplataform
      libsForQt5.qtstyleplugin-kvantum
    ];

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      packages = with pkgs; [
        corefonts # Microsoft free fonts
        ubuntu_font_family # Ubuntu fonts
        unifont
        source-code-pro
        jetbrains-mono # Monospace fonts
      ];
    };

    services.picom = {
      backend = "glx";
      vSync = true;
      opacityRules = [
        # "100:class_g = 'Firefox'"
        # "100:class_g = 'Vivaldi-stable'"
        "100:class_g = 'VirtualBox Machine'"
        # Art/image programs where we need fidelity
        "100:class_g = 'Gimp'"
        "100:class_g = 'Inkscape'"
        "100:class_g = 'aseprite'"
        "100:class_g = 'krita'"
        "100:class_g = 'gnome-photos'"
      ];
      settings = {
        blur-background-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
          "_GTK_FRAME_EXTENTS@:c"
        ];
      };
    };

    env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
    env.QT_QPA_PLATFORMTHEME = "gnome";
    env.QT_STYLE_OVERRIDE = "kvantum";

    services.xserver.displayManager.sessionCommands = ''
      # GTK2_RC_FILES must be available to the display manager.
      export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
    '';

    system.userActivationScripts.cleanupHome = ''
      pushd "${config.user.home}"
      rm -rf .compose-cache .nv .pki .dbus .fehbg
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';
  };
}