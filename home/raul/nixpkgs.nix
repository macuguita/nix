{ inputs, ... }:
{
  dendritic.homeModules."home/raul/nixpkgs" = {
    xdg.config.files."nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';
  };
}
