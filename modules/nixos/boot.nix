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

    initrd = {
      verbose = false;
    };
  };
}
