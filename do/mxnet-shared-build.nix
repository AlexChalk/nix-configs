with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "mxnet-env";
  nativeBuildInputs = [ pkg-config cmake ];
  buildInputs = [
    openblas
    opencv3
    # ? binutils
  ];
}

