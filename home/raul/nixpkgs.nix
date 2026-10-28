{ inputs, ... }:
{
  dendritic.homeModules."home/raul/nixpkgs" = {
    xdg.configFile."nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';
  };
}
