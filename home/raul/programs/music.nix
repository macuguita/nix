{pkgs, lib, ...}:
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

  systemd.user.services.soulseek-tunnel = {
    Unit = {
      Description = "SSH tunnel for Nicotine+ (Soulseek) behind CGNAT";
    };

    Service = {
      ExecStart = "${pkgs.openssh}/bin/ssh -N -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o BatchMode=yes -i %h/.sshKey/opcKey -L 5000:server.slsknet.org:2242 -R 127.0.0.1:2235:127.0.0.1:2234 opc";
      Restart = "always";
      RestartSec = 10;
    };

    Install.WantedBy = [ "default.target" ];
  };

  home.activation.nicotineSoulseek = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    nicotine_cfg="$HOME/.config/nicotine/config"
    mkdir -p "$(dirname "$nicotine_cfg")"
    touch "$nicotine_cfg"

    ${pkgs.python3}/bin/python3 - "$nicotine_cfg" <<'PY'
import configparser
import sys

path = sys.argv[1]
parser = configparser.ConfigParser(
    strict=False, interpolation=None, delimiters=("=",), comment_prefixes=None
)
parser.read(path)

if not parser.has_section("server"):
    parser.add_section("server")

parser.set("server", "server", '("localhost", 5000)')
parser.set("server", "interface", "lo")
parser.set("server", "portrange", "(2234, 2234)")
parser.set("server", "upnp", "False")

with open(path, "w", encoding="utf-8") as handle:
    parser.write(handle)
PY
  '';

  home.packages = with pkgs; [
    feishin
    nicotine-plus
    picard
  ];
}
