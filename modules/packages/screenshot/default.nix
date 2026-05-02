{
  writeShellApplication,
  slurp,
  grim,
  wl-clipboard,
  xdg-user-dirs,
  coreutils,
  bash,
  dunst,
  ...
}:
writeShellApplication {
  name = "screenshot";
  runtimeInputs = [
    slurp
    grim
    wl-clipboard
    xdg-user-dirs
    coreutils
    bash
    dunst
  ];
  text = builtins.readFile ./screenshot.sh;
}
