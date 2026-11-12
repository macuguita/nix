{ inputs, ... }:
{
  dendritic.nixosModules."nixos/vice" = {
    imports = [ inputs.vice.nixosModules.default ];

    # Installs vice-clipper, the uaccess udev rule for the evdev hotkey
    # listener, programs.gpu-screen-recorder (setcap wrapper) and the
    # `vice` user daemon, which auto-starts with the graphical session.
    services.vice.enable = true;
  };
}
