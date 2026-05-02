{
  writeShellApplication,
  pulseaudio,
  easyeffects,
  wf-recorder,
  coreutils,
  bash,
  libnotify,
  ...
}:
writeShellApplication {
  name = "record";
  runtimeInputs = [
    pulseaudio
    easyeffects
    wf-recorder
    coreutils
    bash
    libnotify
  ];
  text = builtins.readFile ./record.sh;
}
