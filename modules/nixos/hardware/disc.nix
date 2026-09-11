{ lib, config, ... }:
let
  inherit (lib.attrsets) filterAttrs;
in
{
  services = {
    fstrim.enable = true;

    btrfs.autoScrub = {
      enable = (config.fileSystems |> filterAttrs (_: fs: fs.fsType == "btrfs")) != { }; # if any filesystems are of type btrfs

      # fileSystems is set automatically
    };
  };
}
