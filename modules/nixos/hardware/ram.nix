{ inputs, ... }:
{
  dendritic.nixosModules."nixos/hardware/ram" =
    { ... }:
    {
      zramSwap = {
        enable = true;
        priority = 100;
      };

      boot.kernel.sysctl."vm.swappiness" = 180;
    };
}
