{ ... }:
{
  dendritic.homeModules."home/raul/programs/music" =
    { pkgs, lib, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) isLinux;
      inherit (lib.modules) mkIf;
    in
    {
      xdg.config.files = mkIf isLinux {
        "navidrome/navidrome.toml".text = ''
          MusicFolder = "/home/raul/Music"
          Address = "127.0.0.1"
          Port = 4533
          DataFolder = "/home/raul/.local/share/navidrome"
        '';

        "nicotine/config" = {
          generator = (pkgs.formats.ini { }).generate "nicotine-config";
          value = {
            server = {
              server = ''("localhost", 5000)'';
              interface = "lo";
              portrange = "(2234, 2234)";
              upnp = "False";
            };
          };
        };
      };

      packages = mkIf isLinux (
        with pkgs;
        [
          nicotine-plus
        ]
      );
    };

  dendritic.nixosModules."nixos/services/music" =
    { pkgs, lib, ... }:
    let
      inherit (pkgs.stdenv.hostPlatform) isLinux;
      inherit (lib.modules) mkIf;
    in
    {
      config = mkIf isLinux {
        systemd.user.services.navidrome = {
          description = "Navidrome Music Server";
          serviceConfig = {
            ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/navidrome";
            ExecStart = "${pkgs.navidrome}/bin/navidrome --configfile %h/.config/navidrome/navidrome.toml";
            Restart = "on-failure";
          };
          wantedBy = [ "default.target" ];
        };

        systemd.user.services.soulseek-tunnel = {
          description = "SSH tunnel for Nicotine+ (Soulseek) behind CGNAT";
          serviceConfig = {
            ExecStart = "${pkgs.openssh}/bin/ssh -N -o ExitOnForwardFailure=yes -o ServerAliveInterval=30 -o ServerAliveCountMax=3 -o BatchMode=yes -i %h/.sshKey/opcKey -L 5000:server.slsknet.org:2242 -R 127.0.0.1:2235:127.0.0.1:2234 opc";
            Restart = "always";
            RestartSec = 10;
          };
          wantedBy = [ "default.target" ];
        };
      };
    };
}
