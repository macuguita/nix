{ config, inputs, ... }:
{
  dendritic.nixosModules."nixos/users" = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      backupFileExtension = "homemanager.bak";
      users.raul = config.dendritic.homeProfiles."raul-linux";
    };

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
