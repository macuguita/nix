{ lib, config, ... }:
{
  services = {
    fstrim.enable = true;

    btrfs.autoScrub = {
      enable = (lib.filterAttrs (_: fs: fs.fsType == "btrfs") config.fileSystems) != { }; # if any filesystems are of type btrfs

      # fileSystems is set automatically
    };
  };
}
