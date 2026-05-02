{ ... }:
{
  boot.initrd.systemd.enable = true; # bashless initrd
  services.userborn.enable = true; # fully declaritive users

  system = {
    nixos-init.enable = true; # bashless* and perl-less* system activation. much less brittle and hopefully a little bit faster.

    etc.overlay = {
      enable = true; # mount etc as an overlay instead of generating it via perl

      # by default, the overlay (and thus /etc) is immutable.
      # this would be a good thing! but unfortunately user passwords are stored in /etc (/etc/shadow and /etc/passwd).
      # i am not comfortable with storing my user password in my configuration (and thus also github), even if it is hashed.
      # unfortunately there is no way to set a password imperatively without making the entirety of /etc mutable.
      mutable = true;
    };
  };
}
