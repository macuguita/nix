{ ... }:
{
  dendritic.homeModules."home/raul/programs/emacs" =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;
      inherit (lib.lists) optionals;
      inherit (lib.modules) mkIf;

      emacs = import ./_package.nix { inherit pkgs lib; };

      emacsclientDesktop = pkgs.writeText "emacsclient.desktop" ''
        [Desktop Entry]
        Name=Emacs Client
        GenericName=Text Editor
        Comment=Edit text
        Exec=${emacs.emacsPkg}/bin/emacsclient -c -a ""
        Icon=emacs
        Type=Application
        Categories=Development;TextEditor;
        StartupNotify=true
        StartupWMClass=Emacs
        MimeType=text/plain;
      '';
    in
    {
      packages = [ emacs.emacsPkg ] ++ optionals isDarwin [ emacs.emacsClientApp ];

      xdg.config.files."emacs/init.el".source = ./init.el;

      xdg.data.files."applications/emacsclient.desktop" = mkIf isLinux {
        source = emacsclientDesktop;
      };

      environment.sessionVariables = {
        EDITOR = "emacsclient -t -a ''";
        VISUAL = "emacsclient -c -a ''";
      };
    };

  # The daemon itself is a platform service.
  dendritic.nixosModules."nixos/programs/emacs" =
    {
      pkgs,
      lib,
      ...
    }:
    let
      emacs = import ./_package.nix { inherit pkgs lib; };
    in
    {
      systemd.user.services.emacs = {
        description = "Emacs daemon";
        wantedBy = [ "default.target" ];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${emacs.emacsPkg}/bin/emacs --fg-daemon";
          ExecStop = "${emacs.emacsPkg}/bin/emacsclient --eval '(kill-emacs)'";
          Restart = "on-failure";
        };
      };
    };

  dendritic.darwinModules."darwin/emacs" =
    {
      pkgs,
      lib,
      ...
    }:
    let
      emacs = import ./_package.nix { inherit pkgs lib; };
    in
    {
      services.emacs = {
        enable = true;
        package = emacs.emacsDaemonPkg;

        # launchd agents get a minimal PATH, which hides nix packages from the
        # daemon: dired fails on BSD ls and git/magit misbehave.
        additionalPath = [
          "/etc/profiles/per-user/raul/bin"
          "/run/current-system/sw/bin"
          "/run/current-system/sw/sbin"
        ];
      };
    };
}
