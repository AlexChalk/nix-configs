{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        anki
        awscli2
        aws-mfa
        # babashka
        binutils
        # (import <nixpkgs-stable> {}).clojure-lsp
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
        # niv
        # nox
        # lorri
        # direnv
        ngrok
        nodejs-12_x
        nodePackages.redoc-cli
        pandoc
        python37
        python37Packages.poetry
        python37Packages.tox
        # python37Packages.debugpy
        # python37Packages.pre-commit
        # python37Packages.python-language-server
        # python37Packages.pyls-isort
        # python37Packages.pyls-black
        # python37Packages.jedi
        # python37Packages.flake8
        # python37Packages.black
        # (import <nixpkgs-stable> {}).python37Packages.pipx
        # pipenv
        rename
        ripgrep
        rlwrap
        ruby
        terraform
        tmux
        tmux-xpanes
        tree
        # universal-ctags
        watchman
        wget
        whois
        yarn
        zathura
        vault
        envconsul
        (callPackage (import ../../packages/neovim.nix) {})
        # cairo
        # gnome2.pango
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
