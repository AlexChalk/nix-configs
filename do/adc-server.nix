{
  network.description = "adc server";

  resources.sshKeyPairs.ssh-key = {};

  adcserver = { config, pkgs, ... }: { 
    environment.systemPackages = with pkgs; [
      git vim zsh
    ];

    services.openssh.enable = true;

    system.autoUpgrade.enable = true;
    system.autoUpgrade.channel = https://nixos.org/channels/nixos-19.03;

    nixpkgs.localSystem.system = "x86_64-linux";

    deployment.targetEnv = "digitalOcean";
    deployment.digitalOcean.enableIpv6 = true;
    deployment.digitalOcean.region = "tor1";
    deployment.digitalOcean.size = "c-8";
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
  # next steps:
  # - use latest channel (env var?) figure out why it's defaulting to 17.09
  # - why is my version of nixops old (17.09 from april at least), how can i get latest
  # - build adc env with adcPackages (run nix-env -i adcPackages for adc)
}
