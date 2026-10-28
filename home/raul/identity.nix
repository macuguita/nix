{ ... }:
{
  dendritic.homeModules."home/raul/identity" =
    {
      pkgs,
      signingKey,
      ...
    }:
    {
      xdg.config.files = {
        "jj/config.toml" = {
          generator = (pkgs.formats.toml { }).generate "jj-config.toml";
          value = {
            user = {
              name = "macuguita";
              email = "me@macuguita.com";
            };
            signing = {
              behavior = "drop";
              backend = "gpg";
              key = signingKey;
            };
            git = {
              sign-on-push = true;
            };
            revset-aliases = {
              "immutable_heads()" = "builtin_immutable_heads() | remote_bookmarks()";
            };
          };
        };

        "git/config".text = ''
          [user]
          name = macuguita
          email = me@macuguita.com
          signingKey = ${signingKey}
          [commit]
          gpgsign = true
          [core]
          excludesFile = ${pkgs.writeText "gitignore" ''
            .jj
            .env
            .DS_Store
          ''}
          [diff]
          algorithm = histogram
          colorMoved = plain
          mnemonicprefix = true
          [fetch]
          prune = true
          [push]
          autoSetupRemote = true
          [init]
          defaultBranch = main
        '';
      };
    };
}
