{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-22.05";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
        };
        ts2vec = pkgs.poetry2nix.mkPoetryApplication {
          projectDir = ./.;
        };
      in
      {
        packages = {
          inherit ts2vec;
        };
        devShells = {
          default = ts2vec.overridePythonAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
              pkgs.poetry
            ];
          });
        };
        devShell = inputs.self.devShells.${system}.default;
      });
}
