{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;

{
  imports =
    [inputs.home-manager.nixosModules.home-manager]
    ++ (mapModulesRec' (toString ./modules) import);

  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

  nix =
    let
      filteredInputs = filterAttrs (n: _: n != "self") inputs;
      nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
      registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
    in {
      package = pkgs.nixFlakes;
      extraOptions = "experimental-features = nix-command flakes";
      
      nixPath = nixPathInputs ++ [
        "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
        "dotfiles=${config.dotfiles.dir}"
      ];
      
      registry = registryInputs
        // { dotfiles.flake = inputs.self; };
      
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        auto-optimise-store = true;
      };
    };

  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "23.05";

  fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";
  
  networking.useDHCP = mkDefault false;

  boot = {
    kernelPackages = mkDefault pkgs.linuxKernel.packages.linux_6_6;
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 5;
      systemd-boot.enable = mkDefault true;
    };
  };

  environment.systemPackages = with pkgs; [
    cached-nix-shell
    git
    vim
    wget
    curl
    gnumake
    unzip
  ];
}