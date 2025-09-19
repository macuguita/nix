{ pkgs, ... }:

pkgs.writeShellScriptBin "youtubeToMP3" ''
  URL="$1"

  [[ -z $URL ]] && echo "Usage: $0 <YouTube_URL>" && exit 1

  ${pkgs.yt-dlp}/bin/yt-dlp --extract-audio --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s" "$URL"

  echo "Download and conversion completed. Files are saved in the current directory."
''
