{ pkgs, ... }:

pkgs.writeShellScriptBin "discordAudio" ''
  INPUT_VIDEO=$1
  OUTPUT_AUDIO=$2

  [[ -z $INPUT_VIDEO ]] && echo "You have to provide a video input!" && exit 1
  [[ -z $OUTPUT_AUDIO ]] && echo "You have to provide a audio output!" && exit 1

  ${pkgs.ffmpeg}/bin/ffmpeg -i "$INPUT_VIDEO" \
      -vn \
      -c:a libopus \
      -b:a 96k \
      -ar 48000 \
      "$OUTPUT_AUDIO"
''
