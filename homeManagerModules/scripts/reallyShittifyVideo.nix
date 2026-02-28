{ pkgs, ... }:

pkgs.writeShellScriptBin "reallyShittifyVideo" ''
  INPUT_VIDEO=$1
  OUTPUT_VIDEO=$2

  [[ -z $INPUT_VIDEO ]] && echo "You have to provide a video input!" && exit 1
  [[ -z $OUTPUT_VIDEO ]] && echo "You have to provide a video output!" && exit 1

  ${pkgs.ffmpeg}/bin/ffmpeg -y -i "$INPUT_VIDEO" \
    -c:v libx264 \
    -preset ultrafast \
    -x264-params qp=51:aq-mode=0:deblock=2,2 \
    -r 3 \
    -g 30 \
    -pix_fmt yuv420p \
    -vf "scale=144:-2:flags=neighbor,fps=3,eq=contrast=2.8:brightness=-0.2:saturation=3,scale=1280:-2:flags=neighbor" \
    -c:a libopus \
    -b:a 6k \
    -ar 8000 \
    -ac 1 \
    -movflags +faststart \
    -map_metadata -1 \
    "$OUTPUT_VIDEO"
''
