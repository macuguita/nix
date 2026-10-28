{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/ghostty" =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
      inherit (lib.lists) singleton;
      inherit (lib.modules) mkIf;
    in
    {
      packages = singleton (if isDarwin then pkgs.ghostty-bin else pkgs.ghostty);

      xdg.config.files = {
        "xdg-terminals.list" = mkIf isLinux {
          text = lib.strings.concatLines (singleton "com.mitchellh.ghostty.desktop");
        };

        "ghostty/config".text = ''
          term = xterm-256color

          font-family = monospace
          font-size = 14

          background = 121212
          foreground = ffffff
          background-opacity = 0.75

          cursor-style = bar

          # Reuse the running Ghostty process for new windows.
          gtk-single-instance = true

          # Keep the process alive after the last window closes so the next launch is instant.
          quit-after-last-window-closed = false
        '';
      };
    };
}
