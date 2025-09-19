{ pkgs, ... }:

pkgs.writeShellScriptBin "changeVolume" ''
  play_feedback() {
      ${pkgs.pulseaudio}/bin/paplay ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/audio-volume-change.oga
  }

  volume_up() {
      is_muted && toggle_mute
      ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+ && play_feedback
  }

  volume_down() {
      is_muted && toggle_mute
      ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%- 5 && play_feedback
  }

  toggle_mute() {
      ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  }

  is_muted() {
      ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '\[MUTED\]'
  }

  case "$1" in
      up) volume_up ;;
      down) volume_down ;;
      mute) toggle_mute ;;
      *) ${pkgs.dunst}/bin/dunstify "Usage: $0 {up|down|mute}" ;;
  esac
''
