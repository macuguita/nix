{ ... }:
{
  macuguita = {
    platform = "darwin";

    signingKey = "40A199C6E6E4D710";

    localAi.enable = false;

    profiles = {
      graphical.enable = true;
    };
  };

  system.stateVersion = 6;
}
