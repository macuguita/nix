{
  description = "Personal NixOS flake";

  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-pandora.url = "github:macuguita/nixpkgs/pandora-launcher-macos-app";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-jetbrains-plugins = {
      url = "github:nix-community/nix-jetbrains-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disabling the follows nixpkgs because it'll miss the caches and take really long to build
    vicinae.url = "github:vicinaehq/vicinae";

    pluey = {
      url = "git+https://tangled.org/macuguita.com/pluey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bedrock-on-linux = {
      url = "github:Wyze3306/BedrockOnLinux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      inherit (inputs.nix-darwin.lib) darwinSystem;
      inherit (nixpkgs.lib) nixosSystem;

      util = import ./util.nix (inputs // { lib = nixpkgs.lib; });
      mkTreefmt =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
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
      mkNixOSConfiguration =
        name: system:
        (nixosSystem {
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
        (darwinSystem {
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

      formatter = util.eachSystem mkTreefmt;

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
              (mkTreefmt system)
            ];
          };
        }
      );
    };
}
