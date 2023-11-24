{ config, lib, ... }:

with builtins;
with lib;
# let blocklist = fetchurl "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"; in
{
  networking.extraHosts = ''
    192.168.1.1   router.home
    # Block garbage
  '';
    # ${optionalString config.services.xserver.enable (readFile blocklist)}

  time.timeZone = mkDefault "America/Sao_Paulo";
  i18n.defaultLocale = mkDefault "pt_BR.UTF-8";
  # Not really needed, but it's here for the sake of being here
  location = {
    latitude = -23.1791;
    longitude = -45.8872;
  };

  # So the vaultwarden CLI knows where to find my server.
  # modules.shell.vaultwarden.config.server = "vault.asfhen.net";
}