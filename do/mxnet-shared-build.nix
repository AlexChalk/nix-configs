# or { jemalloc }: # check docs for how this syntax works
with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "mxnet-env";
  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [
    # binutils
    llvm
    graphviz
    liblapack
    # ^- included with openblas
    jemalloc  # <- need to somehow set paths to both of these as USE_JEMALLOC_PATH/USE_LAPACK_PATH
    openblas
    opencv3
  ];
  makeFlags = [
    "-j $(nproc)"
    "USE_JEMALLOC_PATH=${stdenv.lib.makeLibraryPath [jemalloc]}"
    "USE_LAPACK_PATH=${stdenv.lib.makeLibraryPath [liblapack]}"
    "USE_OPENCV=1"
    "USE_MKLDNN=1"
    "USE_JEMALLOC=1"
    "USE_BLAS=openblas"
  ];

  # makefile = "$HOME/workdir/apache-mxnet/Makefile";

  shellHook = ''
    JEMALLOC_PATH=${stdenv.lib.makeLibraryPath [jemalloc]}
    LAPACK_PATH=${stdenv.lib.makeLibraryPath [liblapack]}
  '';
  # ];
# makeLibraryPath [ pkgs.openssl pkgs.zlib ]

# echo "${pkgs.jemalloc}/lib/libjemalloc.so"
# postFixup = ''
#     for e in $(cd $out/bin && ls); do
#       wrapProgram $out/bin/$e \
#         --prefix PATH : "${gnumake}/bin" \
#         --prefix LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ liblapack blas ]}"
#     done
#   '';
  # maybe
  # cmakeFlags = [
  #   "-DENABLE_JEMALLOC=ON"
  # ];
}
# $(patchelf --print-rpath jemalloc)
