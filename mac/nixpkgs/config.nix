{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        anki
        awscli2
        aws-mfa
        binutils
        curl
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
        ngrok
        nodejs-14_x
        nodePackages.redoc-cli
        pandoc
        (import <nixpkgs-20_09-darwin> {}).python37
        (import <nixpkgs-20_09-darwin> {}).python37Packages.poetry
        (import <nixpkgs-20_09-darwin> {}).python37Packages.tox
        rename
        ripgrep
        rlwrap
        ruby
        terraform
        tmux
        tmux-xpanes
        tree
        watchman
        wget
        whois
        yarn
        zathura
        (import <nixpkgs-20_09-darwin> {}).vault
        envconsul
        (callPackage (import ../../packages/neovim.nix) {})
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
