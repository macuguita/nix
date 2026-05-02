{ ... }:
{
  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;

      allowPing = false;

      logReversePathDrops = true;
      logRefusedConnections = false;
      checkReversePath = false;
    };
  };
}
