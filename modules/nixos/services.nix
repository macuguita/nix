{ config, pkgs, ... }:
{
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      openFirewall = true;
    };

    dbus = {
      enable = true;
      implementation = "broker";
    };

    cloudflare-warp.enable = true;
    tailscale.enable = true;

    gvfs.enable = true;

    # remote desktop
    sunshine = {
      enable = config.macuguita.profiles.graphical.enable;
      autoStart = config.macuguita.profiles.graphical.enable;
      capSysAdmin = config.macuguita.profiles.graphical.enable;
      openFirewall = config.macuguita.profiles.graphical.enable;
    };
  };

  systemd.services.tailscale-serve-navidrome = {
    description = "Expose Navidrome over the tailnet via Tailscale Serve";
    after = [
      "tailscaled.service"
      "tailscaled-autoconnect.service"
    ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg 4533";
    };
  };
}
