{ pkgs, ... }:

pkgs.writeShellScriptBin "record" ''
  start_recording() {
    # Create a virtual combined sink
    ${pkgs.pulseaudio}/bin/pactl load-module module-null-sink sink_name=Combined

    # Load the EasyEffects preset to the virtual sink
    ${pkgs.easyeffects}/bin/easyeffects -p 'Combined' -l "mic_boosted_and_rmnoise" &

    # Loopback mic to Combined sink
    ${pkgs.pulseaudio}/bin/pactl load-module module-loopback sink=Combined source=easyeffects_source

    # Loopback default audio output to Combined sink
    ${pkgs.pulseaudio}/bin/pactl load-module module-loopback sink=Combined source=$(pactl get-default-sink).monitor

    # Start recording from the Combined.monitor
    [[ -d $HOME/Videos ]] || mkdir -p "$HOME/Videos"
    ${pkgs.wf-recorder}/bin/wf-recorder --audio="Combined.monitor" --file="$HOME/Videos/recording_$(date +%d_%m_%Y_%H_%M_%S).mkv" &
    echo $! > /tmp/recpid

    ${pkgs.libnotify}/bin/notify-send -t 500 -h string:bgcolor:#a3be8c "Recording started"
  }

  end() {
    kill -15 "$(cat /tmp/recpid)" && rm -f /tmp/recpid

    # Unload the EasyEffects preset from the virtual sink
    ${pkgs.easyeffects}/bin/easyeffects -p 'Combined' --unload-preset

    # Unload all loopbacks and sinks
    ${pkgs.pulseaudio}/bin/pactl unload-module module-null-sink
    ${pkgs.pulseaudio}/bin/pactl list short modules | grep module-loopback | awk '{print $1}' | xargs -r -n1 pactl unload-module

    ${pkgs.libnotify}/bin/notify-send -t 500 -h string:bgcolor:#bf616a "Recording ended"
  }

  # If the recording pid exists, end recording. If not, start recording
  ([[ -f /tmp/recpid ]] && end && exit 0) || start_recording
''
