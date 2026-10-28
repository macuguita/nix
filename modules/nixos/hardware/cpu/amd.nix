{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware/cpu/amd" =
    { ... }:
    {
      hardware.cpu.amd.updateMicrocode = true;

      boot = {
        kernelModules = [ "kvm-amd" ];
        kernelParams = [ ];
      };
    };
}
