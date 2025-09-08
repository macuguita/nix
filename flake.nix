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
      # Define systems you want to support
      systems = [ "x86_64-linux" "aarch64-linux" ];
      
      # Helper function to create host configurations
      mkHost = { hostname, system, user, modules ? [] }: {
        ${hostname} = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit hostname user; };
          modules = [
            # Host-specific configuration
            ./hosts/${hostname}/configuration.nix
            
            # Home Manager integration
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = import ./hosts/${hostname}/home.nix;
              
              # Apply overlays
              nixpkgs.overlays = [
                neovim-nightly-overlay.overlays.default
              ];
            }
          ] ++ modules; # Add any additional modules
        };
      };
      
      # Define your hosts here
      hosts = [
        {
          hostname = "pc-raul";
          system = "x86_64-linux";
          user = "raul";
        }
        # Add more hosts like this:
        # {
        #   hostname = "laptop";
        #   system = "x86_64-linux";
        #   user = "raul";
        # }
        # {
        #   hostname = "server";
        #   system = "aarch64-linux";
        #   user = "admin";
        # }
      ];
    in
    {
      # Generate nixosConfigurations for all hosts
      nixosConfigurations = nixpkgs.lib.foldl' 
        (acc: host: acc // (mkHost host))
        {}
        hosts;
    };
}
