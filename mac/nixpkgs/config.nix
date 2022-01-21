{
  allowUnfree = true;
  packageOverrides = pkgs: with pkgs; {
    adcPackages = pkgs.buildEnv {
      name = "adc-packages";
      paths = [
        awscli2
        (import <nixpkgs-stable> {}).aws-mfa
        bash
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
        go
        google-cloud-sdk
        heroku
        htop
        jq
        yq
        minikube
        kustomize
        (import <nixpkgs-stable> {}).mysql57
        neofetch
        nodejs-14_x
        nodePackages.bash-language-server
        nodePackages.redoc-cli
        pandoc
        (import <nixpkgs-stable> {}).python37
        (import <nixpkgs-stable> {}).python37Packages.pre-commit
        (import <nixpkgs-stable> {}).python37Packages.tox
        poetry
        python39Packages.pipx
        rename
        ripgrep
        rlwrap
        ruby
        shellcheck
        shfmt
        sonar-scanner-cli
        terraform_0_12
        tmux
        tmux-xpanes
        tree
        watch
        watchman
        wget
        whois
        (import <nixpkgs-stable> {}).yarn
        zathura
        zsh
        vault
        envconsul
        (callPackage (import ../../packages/neovim.nix) {})
      ];
      pathsToLink = [ "/share" "/bin" ];
    };
  };
}
