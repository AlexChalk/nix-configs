{
  allowUnfree = true;
  packageOverrides = pkgs: {
    adcPackages = with pkgs; 
      let 
        python-libs = python-libs: with python-libs; [
          debugpy
        ];
        python3WithLibs = python3.withPackages python-libs;
      in pkgs.buildEnv {
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
          python3WithLibs
          python3Packages.tox
          python3Packages.pipx
          pre-commit
          poetry
          rename
          ripgrep
          rlwrap
          ruby
          shellcheck
          shfmt
          sonar-scanner-cli
          stylua
          (import <nixpkgs-stable> {}).terraform_0_12
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
