{ config, ... }:
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

    sunshine = {
      enable = config.macuguita.profiles.graphical.enable;
      autoStart = config.macuguita.profiles.graphical.enable;
      capSysAdmin = config.macuguita.profiles.graphical.enable;
      openFirewall = config.macuguita.profiles.graphical.enable;
    };
  };
}
