{ config, lib, ... }:

with lib;

let
  cfg = config.services.userUpdate;
in
{
  options = {
    services.userUpdate = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable user update.
        '';
      };
      frequency = mkOption {
        default = "weekly";
        description = ''
          How often to run user update.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.user.timers.user-update = {
      description = "nix-env -iA";
      timerConfig.Persistent = true;
      timerConfig.OnCalendar = cfg.frequency;
      timerConfig.Unit = "user-update.service";
      wantedBy = [ "timers.target" ];
    };

    systemd.user.services.user-update = {
      description = "nix-env -iA";
      script = ''
        curl --head --silent --expect100-timeout 1 --connect-timeout 1 duckduckgo.com >/dev/null 2>&1 || retping=$?

        if [[ -n "$retping" ]]; then
          echo "No connection for update."
          exit 1
        fi

        nix-channel --update
        nix-env -iA nixos.adcPackages
      '';
    };
  };
}
