{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib.attrsets) hasAttr;
  inherit (lib.lists) filter;

  # filterExistingGroups = groups: filter (group: hasAttr group config.users.groups) groups;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../../home
  ];

  users = {
    # mutableUsers = false;

    users.raul = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "nix"
        "audio"
        "pipewire"
        "video"
        "input"
        "network"
        "networkmanager"
        "libvirtd"
        "kvm"
        "i2c"
      ];

      home = "/home/raul";
      uid = 1000;
    };
  };
}
