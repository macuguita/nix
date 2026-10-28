{ inputs, ... }:
{
  dendritic.darwinModules."darwin/graphical" =
    { ... }:
    {
      nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];
    };
}
