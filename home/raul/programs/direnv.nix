{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/direnv" =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        direnv
        nix-direnv
      ];

      xdg.config.files."direnv/direnvrc".text = ''
        : ''${XDG_CACHE_HOME:=$HOME/.cache}
        declare -A direnv_layout_dirs

        direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
            echo -n "$XDG_CACHE_HOME"/direnv/layouts/
            echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
          )}"
        }

        source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc
      '';
    };
}
