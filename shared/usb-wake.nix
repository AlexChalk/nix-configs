{ config, lib, ... }:

let
  inherit (lib) types mkIf mkOption;
  inherit (lib.lists) forEach count;
  inherit (lib.strings) concatStrings;

  cfg = config.services.usbWake;
  device-spec = types.submodule {
    options = {
      vendor-id = mkOption {
        type = types.str;
        description = "USB vendor ID (to the left of the colon in lsusb output)";
      };
      product-id = mkOption {
        type = types.str;
        description = "USB product ID (to the right of the colon in lsusb output)";
      };
    };
  };
  enable = cfg.enable && (count cfg.devices) != 0;
  actions = forEach cfg.devices (device:
    ''
      ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="${device.vendor-id}" ATTRS{idProduct}=="${device.product-id}" ATTR{power/wakeup}="enabled"
    ''
  );
in
{
  options.services.usbWake = {
    enable = mkOption {
      default = false;
      description = ''
        Whether to wake the system with listed USB devices.
      '';
    };
    devices = mkOption {
      type = types.listOf device-spec;
      description = "USB devices that should wake the system.";
      default = [ ];
    };
  };
  config = mkIf enable {
    services.udev.extraRules = concatStrings actions;
  };
}
