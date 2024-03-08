let
  # https://github.com/NixOS/nixpkgs/issues/262000
  pythonPackageOverrides = self: super: {
    debugpy =
      super.debugpy.overridePythonAttrs (old: { doCheck = false; });
  };
in
[
  (final: prev: {
    python3 = prev.python3.override { packageOverrides = pythonPackageOverrides; };
    python3Full = prev.python3Full.override { packageOverrides = pythonPackageOverrides; };
    python3Packages = final.python3.pkgs;
    python3FullPackages = final.python3Full.pkgs;
  })
]
