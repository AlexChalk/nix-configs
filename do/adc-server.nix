{
  network.description = "adc server";

  resources.sshKeyPairs.ssh-key = {};

  adcserver = { config, pkgs, ... }: { 
    environment.noXlibs = true;

    environment.systemPackages = with pkgs; [
      git man vim zsh
    ];

    services.openssh.enable = true;

    system.autoUpgrade.enable = true;
    system.autoUpgrade.channel = https://nixos.org/channels/nixos-19.03;

    nixpkgs.localSystem.system = "x86_64-linux";

    deployment.targetEnv = "digitalOcean";
    deployment.digitalOcean.enableIpv6 = true;
    deployment.digitalOcean.region = "tor1";
    deployment.digitalOcean.size = "c-4";
    # # "c-8" "c-16" "c-32" "s-4vcpu-8gb" maybe "8gb"


    users.users.adc = {
      isNormalUser = true;
      home = "/home/adc";
      shell = pkgs.zsh;
      description = "adc";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = import ./adc-public-key.nix;
    };
  };
}
