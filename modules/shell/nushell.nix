{ config, options, pkgs, lib, ... }:

# TODO: Change to nushell instead of zsh

with lib;
with lib.my;
let cfg = config.modules.shell.nushell;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.nushell = with types; {
    enable = mkBoolOpt false;

    aliases = mkOpt (attrsOf (either str path)) {};
    configFile = mkOpt (listOf path) [];
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.nushell;

    programs = {
      starship.enable = true;
    };

    user.packages = with pkgs; [
      nushell
      carapace
      bat
      eza
      fasd
      fd
      fzf
      jq
      ripgrep
      tldr
    ];

    # home.configFile = {
    #   # Write it recursively so other modules can write files to it
    #   "nushell" = { source = "${configDir}/nushell"; recursive = true; };
    # };
  };
}