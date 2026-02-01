{ pkgs, ... }:

pkgs.writeShellScriptBin "reallyShittifyVideo" ''
  INPUT_VIDEO=$1
  OUTPUT_VIDEO=$2

  [[ -z $INPUT_VIDEO ]] && echo "You have to provide a video input!" && exit 1
  [[ -z $OUTPUT_VIDEO ]] && echo "You have to provide a video output!" && exit 1

  ${pkgs.ffmpeg}/bin/ffmpeg -y -i "$INPUT_VIDEO" \
    -c:v libx264 \
    -preset ultrafast \
    -crf 51 \
    -b:v 30k \
    -r 5 \
    -g 300 \
    -pix_fmt yuv420p \
    -vf "scale=160:90,scale=1280:720:flags=neighbor,eq=contrast=2:brightness=-0.1:saturation=3" \
    -c:a pcm_mulaw \
    -ar 8000 \
    -ac 1 \
    -map_metadata -1 \
    "$OUTPUT_VIDEO"
''

