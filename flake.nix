{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs =
    { nixpkgs
    , home-manager
    , neovim-nightly-overlay
    , nixos-wsl
    , ...
    }:
    let
      mkHost =
        { hostname
        , system
        , user
        , modules ? [ ]
        , isWSL ? false
        ,
        }:
        {
          ${hostname} = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit hostname user; };
            modules =
              [
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
              ]
              ++ (if isWSL then [
                nixos-wsl.nixosModules.default
                {
                  wsl.enable = true;
                  system.stateVersion = "25.05";
                }
              ] else [ ])
              ++ modules;
          };
        };

      hosts = [
        {
          hostname = "pc-raul";
          system = "x86_64-linux";
          user = "raul";
        }
        {
          hostname = "wsl-raul";
          system = "x86_64-linux";
          user = "raul";
          isWSL = true;
        }
      ];
    in
    {
      nixosConfigurations = nixpkgs.lib.foldl' (acc: host: acc // (mkHost host)) { } hosts;
    };
}
