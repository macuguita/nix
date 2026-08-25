{ inputs, ... }:
{
  imports = [
    ../common
    ./shell.nix
    ./users.nix
    ./locale.nix
    ./services.nix
    ./graphical
    inputs.nur.modules.darwin.default
  ];
}
