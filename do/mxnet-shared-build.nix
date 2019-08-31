# or { jemalloc }: # check docs for how this syntax works
with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "mxnet-env";
  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [
    llvm
    gperftools
    graphviz
    liblapack
    jemalloc
    openblas
    opencv3
  ];
}
