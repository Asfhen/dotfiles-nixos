{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vscode;
in {
  options.modules.editors.vscode = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          catppuccin.catppuccin-vsc
          prisma.prisma
          editorconfig.editorconfig
          esbenp.prettier-vscode
          dbaeumer.vscode-eslint
          eamodio.gitlens
          ms-vsliveshare.vsliveshare
          christian-kohler.path-intellisense
          johnpapa.vscode-peacock
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "catppuccin-vsc-icons";
            publisher = "catppuccin";
            version = "0.30.0";
            sha256 = "NuvsvVcz4b41qCDpUYs9yjxmn37paKr4vQPmC4uktv8=";
          }
        ];
      })
    ];
  };
}