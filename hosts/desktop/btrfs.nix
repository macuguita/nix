{ inputs, ... }:
{
  dendritic.nixosModules."hosts/desktop/btrfs" =
    { ... }:
    {
      boot.supportedFilesystems = [ "btrfs" ];

      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = [ "/" ];
      };
    };
}
