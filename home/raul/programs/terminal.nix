{ osConfig, ... }:
{
  programs.foot = {
    enable = osConfig.macuguita.profiles.graphical.enable;
    server.enable = true;

    settings = {
      main = {
        term = "xterm-256color";
        font = "monospace:size=14";
      };
      colors-dark = {
        background = "121212";
        foreground = "ffffff";
        alpha = 0.75;
      };

      cursor.style = "beam";
    };
  };
}
