{ lib, config, ... }:
{
  config = lib.mkIf (config.macuguita.hardware.cpu == "amd") {
    hardware.cpu.amd.updateMicrocode = true;

    boot = {
      kernelModules = [ "kvm-amd" ];
      kernelParams = [ ];
    };
  };
}
