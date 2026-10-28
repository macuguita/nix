{ ... }:
{
  zramSwap = {
    enable = true;
    priority = 100;
  };

  boot.kernel.sysctl."vm.swappiness" = 180;
}
