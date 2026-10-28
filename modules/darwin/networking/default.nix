{ inputs, ... }:
{
  dendritic.darwinModules."darwin/networking" =
    { ... }:
    {
      networking = {
        knownNetworkServices = [
          "Wi-Fi"
          "iPhone USB"
          "USB 10/100/1000 LAN"
          "Thunderbolt Ethernet Slot 0"
        ];

        dns = [
          "1.1.1.2"
          "1.0.0.2"
          "2606:4700:4700::1112"
        ];
      };
    };
}
