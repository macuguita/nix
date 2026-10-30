{
  config,
  ...
}:
let
  nixos = name: config.dendritic.nixosModules."nixos/${name}";
  darwin = name: config.dendritic.darwinModules."darwin/${name}";
  home = name: config.dendritic.homeModules."home/raul/${name}";

  # System groups. Hosts import the groups they need instead of setting
  # `macuguita.*` profile options.
  nixosBase = {
    imports = [
      (nixos "common/nix")
      (nixos "common/nixpkgs")
      (nixos "packages")
      (nixos "nixos-init")
      (nixos "boot")
      (nixos "locale")
      (nixos "security")
      (nixos "shell")
      (nixos "users")
      (nixos "nur")
      (nixos "services")
      (nixos "network")
      (nixos "network/firewall")
      (nixos "network/ssh")
    ];
  };

  nixosHardware = {
    imports = [
      (nixos "hardware")
      (nixos "hardware/audio")
      (nixos "hardware/bluetooth")
      (nixos "hardware/wifi")
      (nixos "hardware/gpu")
      (nixos "hardware/gpu/amd")
      (nixos "hardware/cpu/amd")
      (nixos "hardware/qmk")
      (nixos "hardware/ram")
      (nixos "hardware/disc")
    ];
  };

  nixosGraphical = {
    imports = [
      (nixos "graphical")
      (nixos "graphical/fonts")
      (nixos "graphical/gnome")
      (nixos "programs/emacs")
      (nixos "services/music")
    ];
  };

  nixosGaming = {
    imports = [ (nixos "programs/steam") ];
  };

  darwinBase = {
    imports = [
      (darwin "common/nix")
      (darwin "common/nixpkgs")
      (darwin "packages")
      (darwin "nur")
      (darwin "locale")
      (darwin "services")
      (darwin "shell")
      (darwin "users")
      (darwin "networking")
      (darwin "networking/ssh")
      (darwin "default-apps")
    ];
  };

  # User groups. A host picks the home groups that match its purpose.
  homeBase = {
    imports = [
      (home "shell")
      (home "nixpkgs")
      (home "identity")
      (home "dconf")
      (home "programs/direnv")
      (home "default-apps")
    ];
  };

  homeDesktop = {
    imports = [
      (home "programs/packages")
      (home "programs/emacs")
      (home "programs/vscode")
      (home "programs/jetbrains")
      (home "programs/vesktop")
    ];
  };

  homeLinux = {
    imports = [
      (home "programs/gnome")
      (home "programs/ghostty")
      (home "programs/file-manager")
      (home "programs/music")
      (home "programs/steam")
    ];
  };
in
{
  flake.nixosModules = {
    base = nixosBase;
    hardware = nixosHardware;
    graphical = nixosGraphical;
    gaming = nixosGaming;

    laptop = {
      imports = [ (nixos "hardware/laptop") ];
    };

    local-ai = {
      imports = [ (nixos "local-ai") ];
    };

    desktop = {
      imports = [
        nixosBase
        nixosHardware
        nixosGraphical
        nixosGaming
        (nixos "flatpak")
        (nixos "waydroid")
      ];
    };
  };

  flake.darwinModules = {
    base = darwinBase;

    desktop = {
      imports = [
        darwinBase
        (darwin "graphical")
        (darwin "graphical/fonts")
        (darwin "emacs")
      ];
    };
  };

  # `flake.homeModules` is an alias for this set, so groups and leaves share it.
  dendritic.homeModules = {
    base = homeBase;
    desktop = homeDesktop;
    linux = homeLinux;

    local-ai = {
      imports = [ (home "programs/opencode") ];
    };
  };
}
