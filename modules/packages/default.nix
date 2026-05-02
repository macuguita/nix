{ ... }:
{
  nixpkgs.overlays = [
    (
      self: super:
      let
        pkgs = self.pkgs;
      in
      {
        screenshot = pkgs.callPackage ./screenshot { };
        changeVolume = pkgs.callPackage ./changeVolume { };
        record = pkgs.callPackage ./record { };
        pw-gui = pkgs.callPackage ./pw-gui { };
      }
    )
  ];
}
