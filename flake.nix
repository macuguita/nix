{
  description = "Personal NixOS flake";

  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
      "cgroups"
      "auto-allocate-uids"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-raddebugger.url = "github:MithicSpirit/nixpkgs/raddbg";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
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

    earport = {
      url = "github:Anoryth/earport";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pluey = {
      url = "git+https://tangled.org/macuguita.com/pluey";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kopuz = {
      url = "github:temidaradev/kopuz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bedrock-on-linux = {
      url = "github:Wyze3306/BedrockOnLinux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree [
        ./modules
        ./home
        ./hosts
      ]
    );
}
