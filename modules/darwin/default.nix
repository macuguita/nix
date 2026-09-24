{ inputs, ... }:
{
  imports = [
    ../common
    ./shell.nix
    ./users.nix
    ./locale.nix
    ./services.nix
    ./graphical
    ./networking
    inputs.nur.modules.darwin.default
  ];
}
