{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        anki
        awscli2
        babashka
        binutils
        # clojure-lsp
        curl
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
        pandoc
        poetry
        python3
        python37Packages.flake8
        python37Packages.black
        pipenv
        rename
        ripgrep
        rlwrap
        ruby
        terraform
        tmux
        tmux-xpanes
        tree
        universal-ctags
        watchman
        wget
        whois
        yarn
        zathura
        (callPackage (import ../../packages/neovim.nix) {})
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
