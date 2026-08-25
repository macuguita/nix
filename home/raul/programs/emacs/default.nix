{ pkgs, ... }:
let
  baseEmacs = pkgs.emacs30-pgtk;

  emacsPkg = (pkgs.emacsPackagesFor baseEmacs).emacsWithPackages (epkgs: [
    epkgs.treesit-grammars.with-all-grammars
    epkgs.vterm
  ]);
in
{
  programs.emacs = {
    enable = true;
    package = emacsPkg;
  };

  services.emacs = {
    enable = true;
    package = emacsPkg;
    startWithUserSession = true;
  };

  xdg = {
    configFile."emacs" = {
      source = ./.;
      recursive = true;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "emacsclient.desktop";
        "text/markdown" = "emacsclient.desktop";
        "application/json" = "emacsclient.desktop";
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "emacsclient -t -a ''";
    VISUAL = "emacsclient -c -a ''";
  };
}
