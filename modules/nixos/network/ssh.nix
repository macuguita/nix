{ ... }:
{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;

    allowSFTP = true;

    openFirewall = true;

    ports = [ 22 ];

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AuthenticationMethods = "publickey";
      PubkeyAuthentication = "yes";
      ChallengeResponseAuthentication = "no";

      UsePAM = false;
      UseDns = false;
      X11Forwarding = false;

      ClientAliveCountMax = 5;
      ClientAliveInterval = 60;

      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "sntrup761x25519-sha512@openssh.com"
      ];
    };
  };
}
