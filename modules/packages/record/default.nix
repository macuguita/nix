{
  writeShellApplication,
  pulseaudio,
  easyeffects,
  wf-recorder,
  ffmpeg_7,
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
    (wf-recorder.override {
      ffmpeg = ffmpeg_7;
    })
    coreutils
    bash
    libnotify
  ];
  text = builtins.readFile ./record.sh;
}
