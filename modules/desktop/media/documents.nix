{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.documents;
in {
  options.modules.desktop.media.documents = {
    enable             = mkBoolOpt false;
    pdf.enable         = mkBoolOpt true;
    ebook.enable       = mkBoolOpt true;
    obsidian.enable    = mkBoolOpt true;
    libreoffice.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (mkIf cfg.ebook.enable        calibre)
      (mkIf cfg.pdf.enable          okular)
      (mkIf cfg.obsidian.enable     obsidian)
      (mkIf cfg.libreoffice.enable  libreoffice)
    ];

    # TODO recover books from drive, and configure obsidian
  };
}