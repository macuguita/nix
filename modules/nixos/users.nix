{ inputs, ... }:
{
  dendritic.nixosModules."nixos/users" = {
    imports = [ inputs.hjem.nixosModules.default ];

    hjem.clobberByDefault = true;
    hjem.users.raul = { };

    users.users.raul = {
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
