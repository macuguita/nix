{ pkgs, ... }:

pkgs.writeShellScriptBin "youtubeToMP4" ''
  URL="$1"

  [[ -z $URL ]] && echo "Usage: $0 <YouTube_URL>" && exit 1

  ${pkgs.yt-dlp}/bin/yt-dlp -f "bv+ba/b" --merge-output-format mp4 -o "%(title)s.%(ext)s" "$URL"

  echo "Video download completed. File is saved in the current directory."
''
