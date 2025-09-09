{ config
, lib
, pkgs
, ...
}:

with lib;

{
  options.myNixos.flatpak = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable flatpaks";
    };
  };

  config = lib.mkIf config.myNixos.flatpak.enable {
    services.flatpak.enable = true;
    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      '';
    };
  };
}
