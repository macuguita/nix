{
  config,
  ...
}:
{
  programs.quickshell = {
    enable = true;
    systemd.enable = true;
  };

  xdg.configFile."quickshell" = {
    source = ./.;
  };
}
