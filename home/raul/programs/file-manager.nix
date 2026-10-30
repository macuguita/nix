{ inputs, ... }:
{
  dendritic.homeModules."home/raul/programs/file-manager" =
    { pkgs, ... }:
    {
      packages = [ pkgs.nautilus ];

      dconf.settings = {
        "org/gtk/gtk4/settings/file-chooser" = {
          show-hidden = true;
          sort-directories-first = false;
        };
        "org/gnome/nautilus/icon-view" = {
          default-zoom-level = "small-plus";
        };
      };
    };
}
