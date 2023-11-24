{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
      };
    };

    # TODO: Add my ssh keys
    user.openssh.authorizedKeys.keys =
      if config.user.name == "asfhen"
      then [
        ""
      ]
      else [];
  };
}