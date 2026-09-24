{ ... }:
{
  imports = [
    ./ssh.nix
    ./firewall.nix
  ];

  networking = {
    useNetworkd = true;

    usePredictableInterfaceNames = true;

    nameservers = [
      "1.1.1.2"
      "2606:4700:4700::1112"
    ];

    enableIPv6 = true;
  };

  services.resolved.enable = true;

  systemd = {
    network.wait-online.enable = false;

    services = {
      NetworkManager-wait-online.enable = false;

      # stop networkd and resolved from being restarted when config changes
      systemd-networkd.stopIfChanged = false;
      systemd-resolved.stopIfChanged = false;
    };
  };
}
