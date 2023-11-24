{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      budgie.enable = true;
      apps = {
        bitwarden.enable = true;
        game-engines = {
          enable = true;
          unity3d.enable = true;
          # unreal-engine.enable = false; # Not ready yet
        };
        home-bank.enable = true;
        nextcloud.enable = true;
      };
      browsers = {
        default = "firefox";
        firefox.enable = true;
      };
      gaming = {
        steam.enable = true;
        lutris.enable = true;
        # emulators.enable = true;
        # emulators.psx.enable = true;
      };
      media = {
        daw.enable = true;
        documents.enable = true;
        graphics.enable = true;
        recording.enable = true;
        spotify.enable = true;
      };
      term = {
        default = "tilix";
        tilix.enable = true;
      };
    };
    dev = {
      node.enable = true;
      rust.enable = true;
      python.enable = true;
    };
    editors = {
      default = "vscode";
      vim.enable = true;
    };
    shell = {
      direnv.enable  = true;
      git.enable     = true;
      gnupg.enable   = true;
      tmux.enable    = true;
      nushell.enable = true;
    };
    services = {
      ssh.enable = true;
      docker.enable = true;
    };
    # theme.active = "catppuccin-macchiato";
  };


  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
}