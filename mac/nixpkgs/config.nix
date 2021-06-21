{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        anki
        awscli2
        aws-mfa
        babashka
        binutils
        (import <nixpkgs-stable> {}).clojure-lsp
        curl
        envsubst
        fd
        fzf
        gawk
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
        nodejs-12_x
        nodePackages.redoc-cli
        pandoc
        python37
        python37Packages.poetry
        python37Packages.tox
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
        vault
        envconsul
        (callPackage (import ../../packages/neovim.nix) {})
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
