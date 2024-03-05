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
      path = [ pkgs.libsecret pkgs.calcurse ];
      unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
      script = "calcurse-caldav --init=keep-remote";
      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
