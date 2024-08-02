{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.calendarSync;
in
{
  options = {
    services.calendarSync = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable calendar notifier.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.user.timers.calcurse-caldav = {
      description = "Run calendar import";
      timerConfig.OnBootSec = "1m";
      timerConfig.OnUnitInactiveSec = "1h";
      timerConfig.Unit = "calcurse-caldav.service";
      wantedBy = [ "timers.target" ];
    };

    systemd.user.services.calcurse-caldav = {
      description = "Import calendar";
      path = [ pkgs.curl pkgs.libsecret pkgs.calcurse ];
      unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
      script = ''
        curl --head --silent --expect100-timeout 1 --connect-timeout 1 duckduckgo.com >/dev/null 2>&1 || retping=$?

        if [[ -n "$retping" ]]; then
          echo "No connection for sync."
          exit 1
        fi

        calcurse-caldav --init=keep-remote;
      '';
      serviceConfig = {
        Type = "oneshot";
      };
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };
  };
}
