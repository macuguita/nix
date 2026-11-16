{ ... }:
{
  # Only declares the `dconf.settings` option for the user. The settings
  # themselves are rendered into the system dconf profile by
  # `modules/nixos/graphical/default.nix` (programs.dconf.profiles.user),
  # because GDM owns /etc/dconf/profile/user now and would shadow any
  # per-user profile we installed.
  dendritic.homeModules."home/raul/dconf" =
    { lib, ... }:
    {
      options.dconf.settings = lib.mkOption {
        type = lib.types.attrsOf (lib.types.attrsOf lib.types.anything);
        default = { };
        description = ''
          Per-user dconf settings, keyed by schema path (e.g.
          `"org/gnome/desktop/interface"`). Values use the same GVariant
          constructors as the NixOS dconf module, e.g. `lib.gvariant.mkInt32`.
        '';
      };
    };
}
