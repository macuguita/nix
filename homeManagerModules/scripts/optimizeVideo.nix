{ pkgs, ... }:

pkgs.writeShellScriptBin "optimizeVideo" ''
  INPUT_VIDEO=$1
  OUTPUT_VIDEO=$2

  [[ -z $INPUT_VIDEO ]] && echo "You have to provide a video input!" && exit 1
  [[ -z $OUTPUT_VIDEO ]] && echo "You have to provide a video output!" && exit 1

  ${pkgs.ffmpeg}/bin/ffmpeg -i "$INPUT_VIDEO" \
         -c:v libx264 \
         -preset slow \
         -crf 28 \
         -c:a aac \
         -b:a 128k \
         -pix_fmt yuv420p \
         -vf "scale='min(1280,iw)':'min(720,ih)':force_original_aspect_ratio=decrease,scale=trunc(iw/2)*2:trunc(ih/2)*2" \
         -map_metadata -1 \
         "$OUTPUT_VIDEO"
''
