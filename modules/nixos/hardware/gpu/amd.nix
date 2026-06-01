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

    hardware.graphics.extraPackages = with pkgs; [
      # OpenCL
      rocmPackages.clr
      rocmPackages.clr.icd

      vulkan-loader
    ];
  };
}
