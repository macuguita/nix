{
  description = "Personal NixOS flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-jetbrains-plugins.url = "github:nix-community/nix-jetbrains-plugins";

    catppuccin.url = "github:catppuccin/nix";
    vicinae.url = "github:vicinaehq/vicinae";
    pluey = {
      url = "git+https://tangled.org/macuguita.com/pluey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      util = import ./util.nix (inputs // { lib = nixpkgs.lib; });
      mkNixOSConfiguration =
        name: system:
        (nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit util;
            inherit inputs;
            inherit system;
          };

          modules = [
            ./hosts/${name}
            ./modules/nixos
            ./modules/packages
          ];
        });
      mkDarwinConfiguration =
        name: system:
        (inputs.nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit util;
            inherit inputs;
            inherit system;
          };

          modules = [
            ./hosts/${name}
            ./modules/darwin
            ./modules/packages
          ];
        });
    in
    {
      nixosConfigurations = {
        desktop = mkNixOSConfiguration "desktop" "x86_64-linux";
      };

      darwinConfigurations = {
        mac-raul = mkDarwinConfiguration "mac-raul" "aarch64-darwin";
      };

      devShells = util.eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            buildInputs = with pkgs; [
              nixd
              nixfmt
            ];
          };
        }
      );
    };
}
