{ inputs, ... }:
{
  dendritic.nixosModules."nixos/boot" =
    { pkgs, ... }:
    {
      boot = {
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 10;

            editor = false;
          };
        };
        kernelPackages = pkgs.linuxPackages_latest;

        plymouth = {
          enable = true;
          # default theme (bgrt/spinner); set `theme` to pick another
        };
      };
    };
}
