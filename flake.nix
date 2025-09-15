{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };
  outputs =
    { nixpkgs
    , home-manager
    , neovim-nightly-overlay
    , nixos-wsl
    , nix-darwin
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
    , ...
    }:
    let
      mkHost =
        { hostname
        , system
        , user
        , modules ? [ ]
        , type ? "nixos" # nixos | wsl | darwin
        }:
        if type == "darwin" then
          {
            ${hostname} = nix-darwin.lib.darwinSystem {
              inherit system;
              specialArgs = { inherit hostname user; };
              modules = [
                ./hosts/${hostname}/darwin-configuration.nix
                home-manager.darwinModules.home-manager
                nix-homebrew.darwinModules.nix-homebrew
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.${user} = import ./hosts/${hostname}/home.nix;

                  nixpkgs.overlays = [
                    neovim-nightly-overlay.overlays.default
                  ];

                  nix-homebrew = {
                    enable = true;
                    enableRosetta = true; # Apple Silicon only
                    user = user;

                    taps = {
                      "homebrew/homebrew-core" = homebrew-core;
                      "homebrew/homebrew-cask" = homebrew-cask;
                    };

                    mutableTaps = false;
                  };
                }
                ({ config, ... }: {
                  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
                })
              ] ++ modules;

            };
          }
        else
          {
            ${hostname} = nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = { inherit hostname user; };
              modules = [
                ./hosts/${hostname}/configuration.nix
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.${user} = import ./hosts/${hostname}/home.nix;
                  nixpkgs.overlays = [
                    neovim-nightly-overlay.overlays.default
                  ];
                }
              ] ++ (if type == "wsl" then [
                nixos-wsl.nixosModules.default
                {
                  wsl.enable = true;
                  system.stateVersion = "25.05";
                }
              ] else [ ]) ++ modules;
            };
          };
      hosts = [
        {
          hostname = "pc-raul";
          system = "x86_64-linux";
          user = "raul";
          type = "nixos";
        }
        {
          hostname = "wsl-raul";
          system = "x86_64-linux";
          user = "raul";
          type = "wsl";
        }
        {
          hostname = "mac-raul";
          system = "aarch64-darwin";
          user = "raul";
          type = "darwin";
        }
      ];
    in
    {
      nixosConfigurations =
        nixpkgs.lib.foldl'
          (acc: host:
            if host.type == "darwin"
            then acc
            else acc // (mkHost host)
          )
          { }
          hosts;
      darwinConfigurations =
        nixpkgs.lib.foldl'
          (acc: host:
            if host.type == "darwin"
            then acc // (mkHost host)
            else acc
          )
          { }
          hosts;
    };
}
