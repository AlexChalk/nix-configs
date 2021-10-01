{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        awscli2
        aws-mfa
        binutils
        curl
        eksctl
        envsubst
        fd
        fzf
        gawk
        graphviz
        git
        gitAndTools.gh
        gitAndTools.hub
        gnumake
        gnused
        heroku
        htop
        jq
        mariadb-client
        neofetch
        nodejs-14_x
        nodePackages.redoc-cli
        pandoc
        (import <nixpkgs-stable> {}).python37
        (import <nixpkgs-stable> {}).python37Packages.poetry
        (import <nixpkgs-stable> {}).python37Packages.pre-commit
        (import <nixpkgs-stable> {}).python37Packages.tox
        rename
        ripgrep
        rlwrap
        ruby
        sonar-scanner-cli
        terraform
        tmux
        tmux-xpanes
        tree
        watchman
        wget
        whois
        yarn
        zathura
        zsh
        (import <nixpkgs-20_09-darwin> {}).vault
        envconsul
        (callPackage (import ../../packages/neovim.nix) {})
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
