{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.flakesUpdate;
in
{
  options = {
    services.flakesUpdate = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable flake updates.
        '';
      };
      frequency = mkOption {
        default = "daily";
        description = ''
          How often to update flakes.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.user.timers.flakes-update = {
      description = "nix flake update";
      timerConfig.Persistent = true;
      timerConfig.OnCalendar = cfg.frequency;
      timerConfig.Unit = "flakes-update.service";
      wantedBy = [ "timers.target" ];
    };

    systemd.user.services.flakes-update = {
      description = "nix flake update";
      path = [ pkgs.git ];
      script = ''
        sleep 10

        ${lib.getBin pkgs.curl}/bin/curl --head --silent --expect100-timeout 1 \
          --connect-timeout 1 duckduckgo.com >/dev/null 2>&1 || retping=$?

        if [[ -n "$retping" ]]; then
          echo "No connection for update."
          exit 1
        fi

        ${pkgs.nix}/bin/nix flake update --flake \
          $(${lib.getBin pkgs.coreutils}/bin/dirname \
          $(${lib.getBin pkgs.coreutils}/bin/realpath /etc/nixos/flake.nix)) \
          --commit-lock-file

        ${pkgs.nix}/bin/nix flake update --flake \
          $HOME/nix-configs/nix-profile-linux --commit-lock-file
      '';
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
    };
  };
}
