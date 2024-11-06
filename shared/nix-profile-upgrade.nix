{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nixProfileUpgrade;
in
{
  options = {
    services.nixProfileUpgrade = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable nix profile upgrades.
        '';
      };
      frequency = mkOption {
        default = "weekly";
        description = ''
          How often to run nix profile upgrades.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.user.timers.nix-profile-upgrade = {
      description = "nix profile upgrade";
      timerConfig.Persistent = true;
      timerConfig.OnCalendar = cfg.frequency;
      timerConfig.Unit = "nix-profile-upgrade.service";
      wantedBy = [ "timers.target" ];
    };

    systemd.user.services.nix-profile-upgrade = {
      description = "nix profile upgrade";
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        RestartSec = "1d";
      };
      path = [ pkgs.git ];
      script = ''
        ${lib.getBin pkgs.curl}/bin/curl --head --silent --expect100-timeout 1 \
          --connect-timeout 1 duckduckgo.com >/dev/null 2>&1 || retping=$?

        if [[ -n "$retping" ]]; then
          echo "No connection for upgrade."
          exit 1
        fi

        ${pkgs.nix}/bin/nix profile upgrade nix-profile-linux
      '';
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };
  };
}
