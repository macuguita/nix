{ ... }:

{
  imports = [
    ./flatpak.nix      # default: false
    ./fonts.nix        # default: false
    ./greetd.nix       # default: false
    ./localization.nix # always enabled
    ./samba.nix        # default: false
    ./steam.nix        # default: false
    ./xdgStuff.nix     # default: false
  ];
}
