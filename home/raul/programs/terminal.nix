{ osConfig, ... }:
{
  programs.ghostty = {
    enable = osConfig.macuguita.profiles.graphical.enable;

    settings = {
      term = "xterm-256color";
      keybind = "ctrl+t=new_tab";
      background = "121212";
      foreground = "ffffff";
      background-opacity = 0.75;
      gtk-titlebar = false;
      window-decoration = true;
      confirm-close-surface = false;

      cursor-style = "bar";

      font-size = 11;
    };
  };
}
