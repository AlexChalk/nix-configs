{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.batteryNotifier;
  notifier_script = pkgs.writeScript "low-battery-notifier" ''
    batteries() {
      ${pkgs.findutils}/bin/find /sys/class/power_supply -name 'BAT*'
    }

    capacity() {
      local total=0
      while read -r battery; do
        total=$((total + $(${pkgs.coreutils}/bin/cat "$battery"/capacity)))
      done < <(batteries)
      ${pkgs.coreutils}/bin/echo "$total"
    }

    status() {
      local result='Not Discharging'
      while read -r battery; do
        local status
        status=$(${pkgs.coreutils}/bin/cat "$battery"/status)
        if [[ $status == "Discharging" ]]; then
          result='Discharging'
        fi
      done < <(batteries)
      ${pkgs.coreutils}/bin/echo "$result"
    }

    notify() {
      ${pkgs.libnotify}/bin/notify-send --urgency=critical --expire-time=20000 --hint=int:transient:1 --icon=battery_empty "$1" "$2"
    }

    battery_capacity=$(capacity)
    battery_status=$(status)

    if [[ $battery_capacity -le ${builtins.toString cfg.suspendCapacity} && $battery_status == "Discharging" ]]; then
        notify "Battery Critically Low" "Computer will suspend in 2 minutes."

        sleep 120s

        battery_status=$(status)
        if [[ $(status) = "Discharging" ]]; then
            systemctl suspend
        fi
    fi

    if [[ $battery_capacity -le ${builtins.toString cfg.notifyCapacity} && $battery_status == "Discharging" ]]; then
        notify "Battery Low" "You should probably plug-in."
    fi
  '';
in
{
  options = {
    services.batteryNotifier = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable battery notifier.
        '';
      };
      notifyCapacity = mkOption {
        default = 10;
        description = ''
          Battery level at which a notification shall be sent.
        '';
      };
      suspendCapacity = mkOption {
        default = 5;
        description = ''
          Battery level at which a suspend unless connected shall be sent.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.timers."battery-notifier" = {
      description = "Notify when battery low";
      timerConfig.OnBootSec = "3m";
      timerConfig.OnUnitInactiveSec = "3m";
      timerConfig.Unit = "battery-notifier.service";
      wantedBy = [ "timers.target" ];
    };
    systemd.user.services."battery-notifier" = {
      description = "Notify when battery low";
      script = toString notifier_script;
    };
  };
}
