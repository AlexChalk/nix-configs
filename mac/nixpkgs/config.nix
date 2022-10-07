{
  allowUnfree = true;
  packageOverrides = pkgs: {
    adcPackages = with pkgs;
      let
        python-libs = python-libs: with python-libs; [
          debugpy
        ];
        python3WithLibs = python3.withPackages python-libs;
        rubyWithLibs = ruby_3_1.withPackages (ps: with ps; [ /* rails */ solargraph ]);
        nodejs = nodejs-14_x;
        yarn' = yarn.override { inherit nodejs; };
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
          (import <nixpkgs-stable> { }).gitAndTools.hub
          gnumake
          gnused
          gnutar
          go
          google-cloud-sdk
          graphviz
          heroku
          htop
          imagemagick
          jq
          kustomize
          libyaml
          mysql57
          minikube
          # mp3info
          mp3val
          mysql-shell
          # neofetch
          nodePackages.redoc-cli
          nodejs
          pandoc
          (import <nixpkgs-stable> { }).poetry
          pre-commit
          python3Packages.databricks-cli
          python3Packages.pipx
          python3Packages.tox
          python3WithLibs
          t
          rclone
          rename
          ripgrep
          rlwrap
          rubyWithLibs
          shellcheck
          # sonar-scanner-cli
          tfswitch
          # (import <nixpkgs-stable> { }).terraform_0_13
          # (import <nixpkgs-stable> { }).terraform-providers.template
          texlive.combined.scheme-full
          tmux
          tmux-xpanes
          tree
          vault
          watch
          watchman
          wget
          whois
          yarn'
          yq
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
          sumneko-lua-language-server
          terraform-ls
          texlab
          # linters/diagnostics/formatters
          nodePackages.eslint
          python3Packages.flake8
          python3Packages.reorder-python-imports
          pgformatter
          shfmt
          stylua
          black
          mypy
        ];
        pathsToLink = [ "/share" "/bin" ];
      };
  };
}
