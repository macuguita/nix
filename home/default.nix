{
  util,
  inputs,
  system,
  ...
}:
{
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "homemanager.bak";
    extraSpecialArgs = {
      inherit inputs;
      inherit util;
      inherit system;
    };

    users.raul = ./raul;
  };
}
