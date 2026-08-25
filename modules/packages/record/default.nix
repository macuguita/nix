{ pkgs, ... }:

pkgs.python3Packages.buildPythonApplication {
  pname = "record";
  version = "0.1.0";

  pyproject = false;

  dontUnpack = true;

  propagatedBuildInputs = with pkgs; [
    pulseaudio
    wf-recorder
    libnotify
  ];

  installPhase = ''
    install -Dm755 ${./record.py} $out/bin/record
  '';
}
