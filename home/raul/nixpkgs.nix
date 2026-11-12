{ inputs, ... }:
{
  # config.nix is a nix expression, not a nix.conf settings file, so there is
  # no formats writer for it; keep the literal text.
  dendritic.homeModules."home/raul/nixpkgs" = {
    xdg.config.files."nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';
  };
}
