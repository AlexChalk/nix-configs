with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "mxnet-env";
  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [
    # ? binutils
    graphviz
    jemalloc
    liblapack
    openblas
    opencv3
  ];
}
