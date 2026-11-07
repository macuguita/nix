{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware/audio" =
    { pkgs, ... }:
    {
      services.pipewire = {
        enable = true;

        audio.enable = true;
        pulse.enable = true;

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

      # Launch JACK applications with `pw-jack <app>` instead of relying on a
      # global LD_LIBRARY_PATH.
      environment.systemPackages = [ pkgs.pipewire.jack ];

      # allows programs to choose their scheduling policy, so pipewire can request realtime
      security.rtkit.enable = true;

      systemd.user.services = {
        pipewire.wantedBy = [ "default.target" ];
        pipewire-pulse.wantedBy = [ "default.target" ];
      };
    };
}
