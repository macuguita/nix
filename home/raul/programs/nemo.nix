{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/nemo" =
    { pkgs, ... }:
    {
      packages = [ pkgs.nemo-with-extensions ];

      xdg.data.files = {
        "applications/nemo.desktop".text = ''
          [Desktop Entry]
          Type=Application
          Name=Nemo
          Comment=Access and organize files
          Exec=${pkgs.nemo-with-extensions}/bin/nemo %U
          Icon=system-file-manager
          Terminal=false
          Categories=GNOME;GTK;Utility;Core;
          MimeType=inode/directory;application/x-gnome-saved-search;
        '';
      };
    };

  dendritic.nixosModules."nixos/graphical/nemo-dconf" =
    { ... }:
    {
      programs.dconf.profiles.user.databases = [
        {
          settings = {
            "org/nemo/preferences" = {
              sort-directories-first = false;
              show-hidden-files = true;
            };
            "org/cinnamon/desktop/default-applications/terminal" = {
              exec = "ghostty";
              exec-arg = "-e";
            };
          };
        }
      ];
    };
}
