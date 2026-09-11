{ lib, config, ... }:
let
  inherit (lib.modules) mkIf;
in
{
  config = mkIf (config.macuguita.hardware.cpu == "amd") {
    hardware.cpu.amd.updateMicrocode = true;

    boot = {
      kernelModules = [ "kvm-amd" ];
      kernelParams = [ ];
    };
  };
}
