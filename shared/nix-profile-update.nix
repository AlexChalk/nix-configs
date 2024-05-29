{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nixProfileUpdate;
in
{
  options = {
    services.nixProfileUpdate = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to enable nix profile updates.
        '';
      };
      frequency = mkOption {
        default = "weekly";
        description = ''
          How often to run nix profile updates.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.user.timers.nix-profile-update = {
      description = "nix profile install";
      timerConfig.Persistent = true;
      timerConfig.OnCalendar = cfg.frequency;
      timerConfig.Unit = "nix-profile-update.service";
      wantedBy = [ "timers.target" ];
    };

    systemd.user.services.nix-profile-update = {
      description = "nix profile install";
      path = [ pkgs.git ];
      script = ''
        ${lib.getBin pkgs.curl}/bin/curl --head --silent --expect100-timeout 1 \
          --connect-timeout 1 duckduckgo.com >/dev/null 2>&1 || retping=$?

        if [[ -n "$retping" ]]; then
          echo "No connection for update."
          exit 1
        fi

        ${pkgs.nix}/bin/nix profile install $HOME/nix-configs/nix-profile-linux
      '';
    };
  };
}
