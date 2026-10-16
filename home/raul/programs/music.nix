{pkgs, ...}:
{
  xdg.configFile."navidrome/navidrome.toml".text = ''
    MusicFolder = "/home/raul/Music"
    Address = "127.0.0.1"
    Port = 4533
    DataFolder = "/home/raul/.local/share/navidrome"
  '';

  systemd.user.services.navidrome = {
    Unit = {
      Description = "Navidrome Music Server";
    };

    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/navidrome";
      ExecStart = "${pkgs.navidrome}/bin/navidrome --configfile %h/.config/navidrome/navidrome.toml";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "default.target" ];
  };

  home.packages = with pkgs; [
    feishin
  ];
}
