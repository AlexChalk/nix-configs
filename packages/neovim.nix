{ pkgs, ... }:

let
  runtimePackages = with pkgs; [
    tree-sitter
    # Language servers/formatters for neovim
    clang-tools
    clojure-lsp
    elmPackages.elm-format
    elmPackages.elm-language-server
    gopls
    haskell-language-server
    jdt-language-server
    nixpkgs-fmt
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    pyright
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.vscode-json-languageserver
    nodePackages.yaml-language-server
    nil
    lua-language-server
    terraform-ls
    rubyPackages.solargraph
    rustup # includes rust-analyzer
    sqlfluff
    nodePackages.sql-formatter
    shellcheck
    stylua
    texlab
    # linters/diagnostics/formatters
    eslint
    python3Packages.flake8
    python3Packages.reorder-python-imports
    black
    isort
    mypy
    pgformatter
    shfmt
    yq-go
  ];
  # See https://github.com/nix-community/home-manager/blob/206f457fffdb9a73596a4cb2211a471bd305243d/modules/programs/neovim.nix#L68-L69
  extraMakeWrapperArgs = ''--suffix PATH : "${pkgs.lib.makeBinPath runtimePackages}"'';

  # See https://github.com/NixOS/nixpkgs/blob/d211b80d2944a41899a6ab24009d9729cca05e49/pkgs/applications/editors/neovim/utils.nix#L127-L165
  config = pkgs.neovimUtils.makeNeovimConfig {
    extraPython3Packages = ps: with ps; [ debugpy pyyaml ];

    plugins = with pkgs.vimPlugins; [ fzf-vim fzfWrapper ];
    # Optional plugins: { plugin = optPlugin; optional = true; }

    customLuaRC = ''
      vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'
      dofile(vim.fn.expand("$HOME/.config/nvim/init.lua"))
    '';
  };
in
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (config // {
  wrapperArgs = (pkgs.lib.escapeShellArgs config.wrapperArgs) + " " + extraMakeWrapperArgs;
})
