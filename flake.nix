{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay, ... }:
    let
    systems = [ "x86_64-linux" "aarch64-linux" ];

  mkHost = { hostname, system, user, modules ? [] }: {
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
      ] ++ modules;
    };
  };

  hosts = [
  {
    hostname = "pc-raul";
    system = "x86_64-linux";
    user = "raul";
  }
  ];
  in
  {
    nixosConfigurations = nixpkgs.lib.foldl'
      (acc: host: acc // (mkHost host))
      {}
    hosts;
  };
}
