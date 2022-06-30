{
  allowUnfree = true;
  packageOverrides = pkgs: {
    adcPackages = with pkgs;
      let
        python-libs = python-libs: with python-libs; [
          # debugpy
        ];
        python3WithLibs = (import <nixpkgs-stable> { }).python3.withPackages python-libs;
      in
      pkgs.buildEnv {
        name = "adc-packages";
        paths = [
          (import <nixpkgs-stable> { }).awscli2
          (import <nixpkgs-stable> { }).aws-mfa
          bash
          binutils
          bundix
          curl
          # ddrescue
          eksctl
          envconsul
          envsubst
          fd
          ffmpeg
          flac
          fzf
          gawk
          git
          gitAndTools.gh
          gitAndTools.hub
          gnumake
          gnused
          go
          google-cloud-sdk
          graphviz
          heroku
          htop
          imagemagick
          jq
          kustomize
          libyaml
          mariadb
          minikube
          # mp3info
          mp3val
          # neofetch
          nodePackages.redoc-cli
          nodejs-14_x
          pandoc
          poetry
          pre-commit
          (import <nixpkgs-21-11> { }).python3Packages.pipx
          python3Packages.tox
          python3WithLibs
          rclone
          rename
          ripgrep
          rlwrap
          ruby_3_1
          shellcheck
          # sonar-scanner-cli
          (import <nixpkgs-21-11> { }).terraform_0_12
          texlive.combined.scheme-full
          tmux
          tmux-xpanes
          tree
          vault
          watch
          watchman
          wget
          whois
          (import <nixpkgs-stable> { }).yarn
          (import <nixpkgs-21-11> { }).yq
          zsh
          (callPackage (import ../../packages/neovim.nix) { })
          # language servers
          nodePackages.bash-language-server
          nodePackages.dockerfile-language-server-nodejs
          nodePackages.pyright
          (import <nixpkgs-stable> { }).nodePackages.typescript-language-server
          nodePackages.vscode-langservers-extracted
          nodePackages.vscode-json-languageserver
          nodePackages.yaml-language-server
          rnix-lsp
          rubyPackages.rails
          sumneko-lua-language-server
          terraform-ls
          texlab
          # linters/diagnostics/formatters
          nodePackages.eslint
          python3Packages.flake8
          pgformatter
          rubyPackages.solargraph
          shfmt
          stylua
          (import <nixpkgs-21-11> { }).black
          mypy
        ];
        pathsToLink = [ "/share" "/bin" ];
      };
  };
}
