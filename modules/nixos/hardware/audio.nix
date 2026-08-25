{ lib, config, ... }:
{
  config = lib.mkIf config.macuguita.hardware.audio {
    services.pipewire = {
      enable = true;

      audio.enable = true;
      pulse.enable = true;
      jack.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      wireplumber = {
        enable = true;

        extraConfig.bluetoothEnhancements = {
          "monitor.bluez.properties" = {
            "bluez5.enable-hw-volume" = true;
          };
        };
      };
    };

    # allows programs to choose their scheduling policy, so pipewire can request realtime
    security.rtkit.enable = true;

    systemd.user.services = {
      pipewire.wantedBy = [ "default.target" ];
      pipewire-pulse.wantedBy = [ "default.target" ];
    };
  };
}
