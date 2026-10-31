{ ... }:
{
  dendritic.homeModules."home/raul/dconf" =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) isLinux;
      cfg = config.dconf;

      keyfiles = pkgs.writeTextDir "dconf-settings" (lib.generators.toDconfINI cfg.settings);

      database = pkgs.runCommand "hjem-dconf-db" { nativeBuildInputs = [ pkgs.dconf ]; } ''
        dconf compile $out ${keyfiles}
      '';

      # dconf only treats a profile as writable if the first source is a
      # user/service DB. Keep `user-db:user` first so GNOME Settings and
      # `dconf write` keep working, then use the generated DB as the fallback
      # for keys the user has not overridden.
      profile = pkgs.writeText "dconf-profile" ''
        user-db:user
        file-db:${database}
      '';

      # dconf looks for profiles in /etc/dconf/profile and XDG_DATA_DIRS, not
      # ~/.config/dconf/profile. Installing this in the user profile makes it
      # available through /etc/profiles/per-user/$USER/share.
      profilePackage = pkgs.runCommand "hjem-dconf-profile" { } ''
        mkdir -p $out/share/dconf/profile
        ln -s ${profile} $out/share/dconf/profile/user
      '';
    in
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

      config = lib.mkIf (isLinux && cfg.settings != { }) {
        packages = [ profilePackage ];
      };
    };
}
