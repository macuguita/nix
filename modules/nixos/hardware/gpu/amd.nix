{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware/gpu/amd" =
    { pkgs, ... }:
    {
      services.xserver.videoDrivers = [ "amdgpu" ];
      boot.kernelModules = [ "amdgpu" ];
      nixpkgs.config.rocmSupport = true;

      hardware = {
        i2c.enable = true;

        graphics.extraPackages = with pkgs; [
          # OpenCL
          rocmPackages.clr
          rocmPackages.clr.icd

          vulkan-loader
        ];
      };
    };
}
