{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.macuguita.hardware.gpu == "amd") {
    services.xserver.videoDrivers = [ "amdgpu" ];
    boot.kernelModules = [ "amdgpu" ];

    hardware.i2c.enable = true;

    # OpenCL
    hardware.graphics.extraPackages = with pkgs; [
      rocmPackages.clr
      rocmPackages.clr.icd
    ];
  };
}
