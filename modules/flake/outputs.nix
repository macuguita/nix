{ inputs, lib, ... }:
let
  util = import ../../util.nix (inputs // { inherit lib; });

  mkTreefmt =
    system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    pkgs.treefmt.withConfig {
      runtimeInputs = [ pkgs.nixfmt ];

      settings = {
        excludes = [ ".jj/**" ];

        formatter.nixfmt = {
          command = "nixfmt";
          includes = [ "*.nix" ];
        };
      };
    };
in
{
  flake.formatter = util.eachSystem mkTreefmt;

  flake.devShells = util.eachSystem (
    system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          nixd
          nixfmt
          (mkTreefmt system)
        ];
      };
    }
  );
}
